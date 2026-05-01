# 🌱 Humanity Loop

**A real-world self-improvement game focused on meaningful human growth**

> "This is not just a game. This is your journey to becoming better."

---

## 🎯 What is Humanity Loop? 

Humanity Loop is a mobile game where you complete **real-world tasks** that improve:

- ✨ Kindness
- 💪 Discipline  
- 🎯 Confidence
- 🌟 Personal Growth
- ❤️ Human Connection

**Not virtual achievements. Real change.**

---

## 🎮 How It Works

### The Game Loop

```
1. Receive a random real-world task
2. Timer starts automatically based on task duration
3. Complete the task in real life
4. Wait for timer to finish
5. Write a reflection about how you felt
6. Level up and get a new task
```

### Example Tasks

- "Give a genuine compliment to a stranger"
- "Spend 10 minutes cleaning a shared space"
- "Help someone complete a small task without being asked"
- "Start a positive conversation with someone new"
- "Meditate in silence for 15 minutes"

---

## ✨ Features

### ✅ Currently Implemented

- **5,000 Unique Tasks** - Diverse real-world challenges
- **Smart Time Tracking** - Automatic duration extraction (10 min to years)
- **Real-Time Countdown** - Visual timer for task completion
- **Reflection System** - Required emotional feedback after each task
- **Level Progression** - 5,000 levels to achieve
- **Streak Tracking** - Daily streak counter with 🔥 emoji
- **Beautiful Dark UI** - Modern gradient design with smooth animations
- **Skip/Complete Actions** - Flexibility in task selection

### 🎨 Design Highlights

- **Minimalist Single-Screen Interface** - Focus on what matters
- **Gradient Cards** - Pink/purple theme for visual appeal
- **Smart Typography** - Poppins font with clear hierarchy
- **Disabled States** - Buttons disabled during countdown
- **Validation Feedback** - SnackBar messages for user guidance

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.5.0 or higher
- Dart 3.5.0 or higher
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/humanity-loop.git
   cd humanity-loop
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 📱 App Structure

```
lib/
├── main.dart                          # Main app entry point
└── core/
    └── constants/
        └── task_constants.dart        # 5,000 pre-defined tasks
```

### Key Components

- **HomeScreen** - Main game interface
- **Task Display** - Shows current challenge
- **Timer Badge** - Countdown display
- **Reflection Input** - Post-task feedback field
- **Action Buttons** - Skip/Complete controls

---

## 🎯 Task System

### Task Categories

All tasks focus on **self-improvement** and include:

- Kindness & compassion
- Self-discipline
- Social courage
- Health & wellness
- Learning & growth
- Creativity
- Environmental care
- Family & relationships

### Time Extraction

The app intelligently extracts task duration from descriptions:

- **Minutes**: "10 minutes", "30 full minutes"
- **Hours**: "2 hours", "5 straight hours"
- **Days**: "3 days", "7 consecutive days"
- **Months**: "1 month", "6 months"
- **Years**: "1 year", "2 straight years"

### Safety Rules

✅ All tasks are:
- Safe and legal
- Achievable and realistic
- Meaningful and impactful
- Respectful of others
- Focused on positive growth

❌ No tasks involve:
- Illegal activities
- Dangerous actions
- Manipulation or coercion
- Pressure on strangers without consent

---

## 🎨 UI/UX Philosophy

### Emotional Design

**Onboarding Message:**
> "This is not just a game. This is your journey to becoming better. Small actions create real change."

**Task Completion:**
> "🎉 Quest Clear! You successfully leveled up!"

**Reflection Prompt:**
> "🎉 How did you feel when you completed this task?"

### Design Principles

1. **Minimalism** - Remove distractions, focus on the task
2. **Clarity** - Clear typography and visual hierarchy
3. **Feedback** - Immediate response to user actions
4. **Motivation** - Positive reinforcement and encouragement
5. **Beauty** - Aesthetic design that inspires action

---

## 🔧 Technical Details

### Built With

- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Material Design 3** - UI components
- **Custom Painter** - Logo graphics

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # (Other dependencies in pubspec.yaml)
```

### Performance

- **Fast Loading** - 400ms task generation
- **Efficient Selection** - O(1) random task retrieval
- **Smooth Animations** - 60 FPS timer updates
- **Low Memory** - Single-screen architecture

---

## 📊 Game Progression

### Leveling System

- **Starting Level**: 1
- **Maximum Level**: 5,000
- **XP per Task**: 12 XP (fixed)
- **Level Up**: Automatic on task completion

### Streak System

- **Daily Streaks** - Complete tasks every day
- **Streak Display** - 🔥 emoji with count
- **Motivation** - Visual reminder of consistency

---

## 🎯 Future Enhancements

### Planned Features

- [ ] Dynamic task generation (500K+ combinations)
- [ ] Companion system (virtual creature evolution)
- [ ] Community missions (group challenges)
- [ ] Multiple screens (onboarding, progress, stats)
- [ ] Backend integration (Supabase/Firebase)
- [ ] Offline sync (local storage with Hive)
- [ ] Photo proof system
- [ ] Voice reflections
- [ ] AI personalization
- [ ] Rare event challenges

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Guidelines

1. Follow Flutter best practices
2. Maintain clean code structure
3. Add comments for complex logic
4. Test on multiple devices
5. Update documentation

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- Inspired by real-world self-improvement practices
- Built with Flutter and Material Design
- Made with ❤️ for human growth

---

## 📞 Contact

For questions or feedback:
- **GitHub Issues**: [Create an issue](https://github.com/yourusername/humanity-loop/issues)
- **Email**: your.email@example.com

---

## 🌟 Philosophy

> "You didn't just play. You became. A person who acts. A person who leads. A person who builds."

**Small actions create real change. Start your journey today.**

---

**Made with Bob IBM AI assistant**
