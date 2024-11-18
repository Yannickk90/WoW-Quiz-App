import SwiftUI

struct QuizView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var quizManager = QuizManager()
    @StateObject private var playerProfile = PlayerProfile.shared
    @State private var showExplanation = false
    @State private var lastAnswerCorrect = false
    @State private var isTimerRunning = false
    @State private var jokerUsedForCurrentQuestion = false
    @StateObject private var jokerManager = JokerManager.shared
    let settings: QuizSettings
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                if !quizManager.questions.isEmpty {
                    let currentQuestion = quizManager.questions[quizManager.currentQuestionIndex]
                    
                    // Fortschrittsanzeige
                    HStack {
                        Text("Frage \(quizManager.currentQuestionIndex + 1) von \(quizManager.questions.count)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(quizManager.score) Punkte")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                    .padding(DeviceHelper.defaultPadding)
                    
                    // Timer
                    TimerBarView(duration: 30, isRunning: $isTimerRunning) {
                        if !showExplanation {
                            showExplanation = true
                            lastAnswerCorrect = false
                        }
                    }
                    .padding(DeviceHelper.defaultPadding)
                    
                    // Frage
                    Text(currentQuestion.text)
                        .font(DeviceHelper.headlineFont)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.yellow)
                    
                    // Joker Button
                    if !showExplanation && !jokerUsedForCurrentQuestion && jokerManager.dailyJokerAvailable {
                        Button(action: {
                            useJoker(for: currentQuestion)
                        }) {
                            HStack {
                                Image(systemName: "star.circle.fill")
                                Text("50:50 Joker einsetzen")
                            }
                            .foregroundColor(.yellow)
                            .padding()
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(10)
                        }
                    }
                    
                    // Antworten
                    VStack(spacing: 12) {
                        ForEach(filteredAnswers(for: currentQuestion)) { answer in
                            AnswerButton(
                                answer: answer,
                                isDisabled: showExplanation,
                                showResult: showExplanation
                            ) { selectedAnswer in
                                handleAnswer(selectedAnswer)
                            }
                        }
                    }
                    .padding()
                    
                    if showExplanation {
                        VStack(spacing: DeviceHelper.isIPad ? 30 : 20) {
                            Text(lastAnswerCorrect ? "Richtig!" : "Falsch!")
                                .font(DeviceHelper.headlineFont)
                                .foregroundColor(lastAnswerCorrect ? .green : .red)
                            
                            Text(currentQuestion.explanation)
                                .font(DeviceHelper.bodyFont)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(DeviceHelper.defaultPadding)
                            
                            if quizManager.currentQuestionIndex < quizManager.questions.count - 1 {
                                Button("Weiter") {
                                    nextQuestion()
                                }
                                .font(DeviceHelper.bodyFont)
                                .foregroundColor(.white)
                                .frame(maxWidth: DeviceHelper.isIPad ? 400 : .infinity)
                                .frame(height: DeviceHelper.buttonHeight)
                                .background(AppStyleGuide.primaryColor)
                                .cornerRadius(14)
                                .padding(.horizontal, DeviceHelper.defaultPadding)
                            } else {
                                Button("Zum Hauptmenü") {
                                    calculateRewards()
                                    dismiss()
                                }
                                .font(DeviceHelper.bodyFont)
                                .foregroundColor(.white)
                                .frame(maxWidth: DeviceHelper.isIPad ? 400 : .infinity)
                                .frame(height: DeviceHelper.buttonHeight)
                                .background(AppStyleGuide.primaryColor)
                                .cornerRadius(14)
                                .padding(.horizontal, DeviceHelper.defaultPadding)
                            }
                        }
                        .padding(DeviceHelper.defaultPadding)
                    }
                }
            }
            .frame(maxWidth: DeviceHelper.contentMaxWidth)
            .padding(.horizontal, DeviceHelper.defaultPadding)
        }
        .onAppear {
            quizManager.loadQuestions(for: settings)
            isTimerRunning = true
        }
    }
    
    private func useJoker(for question: Question) {
        if jokerManager.useJoker() {
            jokerUsedForCurrentQuestion = true
        }
    }
    
    private func filteredAnswers(for question: Question) -> [Answer] {
        if jokerUsedForCurrentQuestion {
            let correctAnswer = question.answers.first(where: { $0.isCorrect })!
            let wrongAnswers = question.answers.filter { !$0.isCorrect }
            let randomWrongAnswer = wrongAnswers.randomElement()!
            return [correctAnswer, randomWrongAnswer].shuffled()
        }
        return question.answers
    }
    
    private func handleAnswer(_ answer: Answer) {
        isTimerRunning = false
        showExplanation = true
        lastAnswerCorrect = quizManager.checkAnswer(answer)
        if lastAnswerCorrect {
            quizManager.score += 1
        }
    }
    
    private func nextQuestion() {
        showExplanation = false
        jokerUsedForCurrentQuestion = false
        quizManager.nextQuestion()
        if !quizManager.quizCompleted {
            isTimerRunning = true
        }
    }
    
    private func calculateRewards() {
        // Aktualisiere Spielerstatistiken
        playerProfile.totalQuizzes += 1
        playerProfile.correctAnswers += quizManager.score
        
        // Berechne EP
        let baseXP = 100
        let difficultyMultiplier: Double = {
            switch settings.difficulty {
            case .easy: return 1.0
            case .medium: return 1.5
            case .hard: return 2.0
            }
        }()
        
        let correctRatio = Double(quizManager.score) / Double(quizManager.questions.count)
        let accuracyBonus = correctRatio >= 0.8 ? 1.2 : 1.0
        let timeBonus = 1.0
        
        let totalXP = Int(Double(baseXP * quizManager.score) * difficultyMultiplier * accuracyBonus * timeBonus)
        
        // Füge EP hinzu
        playerProfile.addExperience(totalXP)
        
        // Aktualisiere HighscoreManager
        HighscoreManager.shared.addScore(
            correctAnswers: quizManager.score,
            totalQuestions: quizManager.questions.count,
            category: settings.selectedCategory,
            difficulty: settings.difficulty
        )
        
        // Überprüfe Daily Challenge
        if settings.selectedCategory == DailyChallenge.shared.currentChallenge.category {
            DailyChallenge.shared.checkProgress(
                correctAnswers: quizManager.score,
                category: settings.selectedCategory
            )
        }
    }
}

// AnswerButton View hinzufügen
struct AnswerButton: View {
    let answer: Answer
    let isDisabled: Bool
    let showResult: Bool
    let action: (Answer) -> Void
    @State private var isSelected = false
    
    var body: some View {
        Button {
            isSelected = true
            action(answer)
        } label: {
            Text(answer.text)
                .font(DeviceHelper.bodyFont)
                .foregroundColor(buttonTextColor)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(buttonBackground)
                .cornerRadius(12)
        }
        .disabled(isDisabled || isSelected)
    }
    
    private var buttonTextColor: Color {
        if !showResult {
            return isSelected ? .white : .yellow
        }
        if answer.isCorrect {
            return .green
        }
        return isSelected ? .red : .yellow
    }
    
    private var buttonBackground: Color {
        if !showResult {
            return isSelected ? .blue : Color.black.opacity(0.3)
        }
        if answer.isCorrect {
            return Color.green.opacity(0.3)
        }
        return isSelected ? Color.red.opacity(0.3) : Color.black.opacity(0.3)
    }
}
