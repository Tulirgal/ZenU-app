

class TertiaryData {
  final String affirmation;
  final String tip;
  final List<ModuleRef> modules;
  const TertiaryData({required this.affirmation, required this.tip, required this.modules});
}

class ModuleRef {
  final String name;
  final String route;
  final String emoji;
  const ModuleRef({required this.name, required this.route, required this.emoji});
}

const Map<String, TertiaryData> tertiaryData = {
  // ANGRY subtree
  "betrayed": TertiaryData(
    affirmation: "Being betrayed by someone you trusted is one of the deepest hurts. Your anger is not an overreaction — it is love meeting a broken promise. You are allowed to feel this fully.",
    tip: "Write out what happened without filtering yourself — getting it out of your head reduces its weight.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "resentful": TertiaryData(
    affirmation: "Resentment builds when something you needed was not given. That is not your fault. Carrying it is exhausting though — writing it out can help you see what you actually need.",
    tip: "Journaling resentment without judgment often reveals the unmet need underneath.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),
  "disrespected": TertiaryData(
    affirmation: "Your dignity matters. Feeling disrespected is a signal that a real boundary was crossed. You are not being too sensitive — you are being human.",
    tip: "Physical release first, then clarity. Try breathing or the burst module before thinking it through.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "ridiculed": TertiaryData(
    affirmation: "Being ridiculed hits at our deepest need for belonging and safety. Their words reflect their own limitations, not your worth. You did not deserve that.",
    tip: "Write down the exact opposite of what was said to you — claim your own truth.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
  "indignant": TertiaryData(
    affirmation: "Indignation is anger mixed with a sense of injustice. You are seeing something that is wrong. That clarity is a strength, even if it feels heavy right now.",
    tip: "Write out what should have happened to help you process what did.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "violated": TertiaryData(
    affirmation: "When a boundary is crossed without consent, the body and mind both react strongly. What you are feeling is a natural response to something that was not okay. Please be gentle with yourself.",
    tip: "Talking to someone — even an AI companion — can help you process this safely.",
    modules: [
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "furious": TertiaryData(
    affirmation: "Fury is anger at full volume. Something important was seriously threatened or harmed. This intensity needs somewhere to go — give it a safe outlet before it burns you from the inside.",
    tip: "Physical release is the fastest way to discharge fury safely.",
    modules: [
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "jealous": TertiaryData(
    affirmation: "Jealousy often points to something you deeply want for yourself. It is not a character flaw — it is information. What is it showing you that you actually desire?",
    tip: "Writing honestly about jealousy without shame is surprisingly clarifying.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),
  "provoked": TertiaryData(
    affirmation: "Something or someone pushed your buttons deliberately or carelessly. Your reaction is human. Taking a moment before responding is not weakness — it is strategy.",
    tip: "A breathing reset gives you the pause you need before reacting.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "hostile": TertiaryData(
    affirmation: "Hostility builds when we have felt threatened for too long. Your guard is up because something taught you it needed to be. That protection made sense once — and you are safe enough right now to let a little of it down.",
    tip: "Mindfulness helps lower the defensive wall without making you vulnerable.",
    modules: [
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "infuriated": TertiaryData(
    affirmation: "Being infuriated means something crossed a line that really mattered. That reaction is real and valid. Find a way to release the energy safely before making any decisions.",
    tip: "Physical expression of emotion — bursting, breathing — comes before thinking.",
    modules: [
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "annoyed": TertiaryData(
    affirmation: "Annoyance is friction — small things rubbing the wrong way. It is often a sign you need more space, rest, or simply a reset. Give yourself permission to step away for a moment.",
    tip: "Even three minutes of something calm can dissolve annoyance completely.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "withdrawn": TertiaryData(
    affirmation: "Withdrawing is sometimes the wisest thing — your system is protecting you. Honour that need for space while also keeping one small thread of connection alive.",
    tip: "Gentle solo activities keep you present without demanding too much.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "numb": TertiaryData(
    affirmation: "Numbness is often what happens after feeling too much for too long — your mind's protection. You do not need to force yourself to feel. Be here gently, without pressure.",
    tip: "Gentle sensory experiences — slow breathing, soft visuals — help you reconnect gradually.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "skeptical": TertiaryData(
    affirmation: "Skepticism means your mind is protecting you from being misled. That instinct has value. Make sure it is protecting you and not closing you off from things that could genuinely help.",
    tip: "Writing out what you are skeptical about helps separate useful caution from fear.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "dismissive": TertiaryData(
    affirmation: "When we feel dismissive, it is often because something is hitting too close to something we are not ready to look at. That is okay. You do not have to open every door today.",
    tip: "Mindfulness helps you observe your own reactions without judgment.",
    modules: [
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  
  // DISGUSTED subtree
  "judgmental": TertiaryData(
    affirmation: "Noticing that you are being judgmental is itself a moment of self-awareness — most people do not catch it. Ask yourself what standard is not being met, and whether that standard is fair to apply here.",
    tip: "Journaling your judgments without acting on them is a healthy release.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "embarrassed": TertiaryData(
    affirmation: "Embarrassment is the pain of feeling seen in a way we did not choose. It fades faster than it feels like it will. You are not defined by this moment.",
    tip: "Writing about embarrassment privately often makes it lose its power.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),
  "appalled": TertiaryData(
    affirmation: "Something crossed a moral line for you — your values reacted strongly. That reaction reflects the quality of your character. Take a breath and give yourself space to process this.",
    tip: "Breathe first. Moral shock needs time to settle before you can respond well.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "revolted": TertiaryData(
    affirmation: "Revulsion is a strong signal from your gut — something deeply conflicts with your values or sense of safety. Trust that signal. You are allowed to remove yourself from what feels wrong.",
    tip: "Grounding your body helps after a strong visceral reaction.",
    modules: [
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "nauseated": TertiaryData(
    affirmation: "When disgust is so strong it turns physical, your body is protecting you aggressively. Honor that physical reality. Step away, drink water, and reset your senses.",
    tip: "Slow, rhythmic breathing signals safety to your nervous system.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "detestable": TertiaryData(
    affirmation: "Feeling something is detestable means a core part of you rejects it entirely. You do not have to accept or tolerate what harms you. Trust your rejection.",
    tip: "Writing it out can help you articulate exactly what boundary was crossed.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
    ],
  ),
  "horrified": TertiaryData(
    affirmation: "Horror is fear and disgust combined. It is a massive shock to the system. You are safe in this exact moment. Let your body register that it is safe right now.",
    tip: "Grounding exercises pull you out of the shock and back into the present moment.",
    modules: [
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "hesitant": TertiaryData(
    affirmation: "Hesitation is not weakness — it is your intuition asking for a pause. You are allowed to wait until you have more information or feel more secure. Do not rush.",
    tip: "Use this pause to explore what your intuition is trying to tell you.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  
  // SAD subtree
  "fragile": TertiaryData(
    affirmation: "Feeling fragile means you have been carrying too much without enough rest or support. It is okay to put the weight down. It is okay to protect your energy right now.",
    tip: "The Healing Garden is a safe, gentle place when you feel delicate.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "rejected": TertiaryData(
    affirmation: "Rejection hurts because we are wired to need connection. This pain is ancient and real, but it does not measure your worth. You belong here. You matter.",
    tip: "Talking to Seviyan can offer a judgment-free space to feel heard today.",
    modules: [
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),
  "inferior": TertiaryData(
    affirmation: "Feeling inferior usually comes from comparing our insides to other people's carefully curated outsides. Your path is yours alone. What you are is enough.",
    tip: "Remind yourself of what you have done and who you are.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),
  "empty": TertiaryData(
    affirmation: "Emptiness is exhausting. It feels like running on fumes. You do not need to fill the space immediately. Sometimes you just have to rest until the tide comes back in.",
    tip: "Gentle mindfulness can help you rest in the emptiness without fearing it.",
    modules: [
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "powerless": TertiaryData(
    affirmation: "When everything feels out of your hands, the world is terrifying. Find one small thing you can control right now — even just your breath or a small task. Start there.",
    tip: "Completing one small task in the Healing Garden reclaims a sense of agency.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "grief": TertiaryData(
    affirmation: "Grief is love that has nowhere to go. It is a heavy, necessary process. There is no timeline for this, and no right way to do it. Just take it one breath at a time.",
    tip: "Writing about what you lost honors it and helps release the pressure.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "abandoned": TertiaryData(
    affirmation: "The feeling of being left behind is profoundly isolating. You are not alone, even though it feels that way right now. Please be the one who stays with yourself today.",
    tip: "Connect with Seviyan for a gentle, present conversation.",
    modules: [
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "isolated": TertiaryData(
    affirmation: "Isolation is a cold place. Reaching out feels impossible right now. It is okay to start small. You are part of this world, and you are seen.",
    tip: "Practicing gratitude can slowly rebuild the bridge between you and the world.",
    modules: [
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),

  // HAPPY subtree
  "inspired": TertiaryData(
    affirmation: "Inspiration is a rare and beautiful spark. Something resonated with the deepest part of you. Hold onto this feeling — let it pull you toward what matters.",
    tip: "Capture the inspiration immediately before it fades.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
  "hopeful": TertiaryData(
    affirmation: "Hope is a quiet strength. It means you can see a future where things are better, and you believe you can reach it. Nurture this — it is the fuel for everything else.",
    tip: "Write down exactly what you are hoping for right now.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),
  "playful": TertiaryData(
    affirmation: "Playfulness means you feel safe enough to let go of the rules. That is a wonderful place to be. Enjoy it fully — joy does not need to be productive.",
    tip: "Let this energy out somewhere fun and unconstrained.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
  "affectionate": TertiaryData(
    affirmation: "Affection is your capacity for love overflowing. It is a gift to feel this warmly toward others or yourself. Let it radiate.",
    tip: "Gratitude journaling channels love into something lasting.",
    modules: [
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "content": TertiaryData(
    affirmation: "Contentment is underrated — it is the feeling of enough, right now. Stay here a little longer. Let this settle into your body. You earned this peace.",
    tip: "Deepen this contentment with a gentle mindfulness practice.",
    modules: [
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
  "courageous": TertiaryData(
    affirmation: "You are feeling brave right now — that is not an accident. Something in you is ready. Move while this window is open. Courage is a muscle and you are using it.",
    tip: "Plant a big task in your Healing Garden while you feel this way.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "creative": TertiaryData(
    affirmation: "Creative energy is flowing right now — that is precious. Everything you make while feeling this way will have something real in it. Use this window.",
    tip: "Start something new — even a small experiment — right now.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
  "respected": TertiaryData(
    affirmation: "Feeling respected means something was given to you that you deserved — acknowledgment of your worth. Sit with that. Let it be real. You can be proud of what earned this.",
    tip: "Write about what you did or who you are that brought this about.",
    modules: [
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "valued": TertiaryData(
    affirmation: "Being valued is one of the deepest needs a person has — and right now it is being met. Notice this fully. Remember how it feels so you can seek it out again.",
    tip: "Capture this feeling before it fades.",
    modules: [
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
  "successful": TertiaryData(
    affirmation: "You did something and it worked. Do not rush past this — let yourself feel it completely. Success that is not acknowledged does not motivate the next attempt.",
    tip: "Mark this in your Healing Garden as a tree grown.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),
  "confident": TertiaryData(
    affirmation: "Confidence is not the absence of doubt — it is moving forward despite it. You feel ready right now. Trust that. Use this energy while it is available to you.",
    tip: "Write down what you are about to do while you feel this way.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "curious": TertiaryData(
    affirmation: "Curiosity is one of the most alive feelings there is — it means you are engaged with the world and want to understand it better. Follow this thread. See where it goes.",
    tip: "Make something based on what you are curious about.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "inquisitive": TertiaryData(
    affirmation: "Your mind is asking questions — that is intelligence doing its job. Write the questions down. Some of them hold more than you realize.",
    tip: "Questions journaled often answer themselves over time.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "free": TertiaryData(
    affirmation: "Freedom is rare and worth celebrating. Something that was heavy has lifted. Breathe into this space — it belongs to you right now.",
    tip: "Create freely — no rules, no judgment, just expression.",
    modules: [
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),
  "excited": TertiaryData(
    affirmation: "That spark of excitement is rare and real — let it breathe. Your energy right now is a gift. Channel it into something that matters to you before it disperses.",
    tip: "Use this energy to plant something new in your Healing Garden.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),

  // SURPRISED subtree
  "shocked": TertiaryData(
    affirmation: "Your system just received something it was not ready for. That is okay. You do not need to react immediately. Take five slow breaths and let your mind catch up to what happened.",
    tip: "Your nervous system needs to settle before you can think clearly.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "dismayed": TertiaryData(
    affirmation: "Dismay is the feeling of seeing something you hoped would be different turn out not to be. Give yourself time to adjust your expectations. This is a real process that takes real time.",
    tip: "Writing out what you hoped for versus what happened brings clarity.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "disillusioned": TertiaryData(
    affirmation: "Disillusionment is painful but it is also growth — you are seeing something more clearly than you did before. The clarity, even though it hurts, is worth having.",
    tip: "Journal what you thought versus what you now know — this processes the gap.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "perplexed": TertiaryData(
    affirmation: "Perplexity means something is more complex than it first appeared — and your mind is working hard to make sense of it. That is good thinking. Give it the time it needs.",
    tip: "Writing out what you do and do not understand often brings clarity.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "awe": TertiaryData(
    affirmation: "Awe is one of the most expansive feelings a human can have — it means something made you feel small in the best possible way. The world is bigger and more beautiful than ordinary life lets you see. Stay here a moment.",
    tip: "Capture this feeling — it is worth preserving.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
    ],
  ),
  "astonished": TertiaryData(
    affirmation: "Astonishment pulls you completely into the present moment. Something just rewrote what you thought was possible. Let yourself be amazed.",
    tip: "Record this exact moment so you can look back on it.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "eager": TertiaryData(
    affirmation: "Eagerness is forward-looking energy. You are ready for what comes next. It is a great feeling to have — ride that momentum while it is here.",
    tip: "Channel this energy into something productive right now.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
  "energetic": TertiaryData(
    affirmation: "You have fuel in the tank right now! Your body and mind are primed to move. Do not waste this on something small — aim it at something you care about.",
    tip: "Start a task you have been putting off.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),

  // FEARFUL subtree
  "helpless": TertiaryData(
    affirmation: "Helplessness is terrifying because it feels like you have no agency. But you always have one choice: how you treat yourself right now. Be kind to the part of you that is scared.",
    tip: "Find one tiny thing you can control right now — even just your breath.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "frightened": TertiaryData(
    affirmation: "Fear is your system trying to keep you safe. Thank it for doing its job, but remind it that you are safe in this exact moment. You can handle what is in front of you.",
    tip: "Grounding exercises remind your body that the threat is not here right now.",
    modules: [
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "overwhelmed": TertiaryData(
    affirmation: "Overwhelm means there is too much input and not enough space to process it. The solution is not to process faster — it is to stop the input. Step back. Give yourself a minute.",
    tip: "A breathing reset slows everything down immediately.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
    ],
  ),
  "worried": TertiaryData(
    affirmation: "Worry is your mind trying to solve a problem that has not happened yet. It feels productive, but it is just spinning wheels. Bring your attention back to what is actually happening right now.",
    tip: "Writing down your worries gets them out of the echo chamber of your mind.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "inadequate": TertiaryData(
    affirmation: "Feeling inadequate usually means you are judging yourself against a standard you did not choose. You are allowed to be exactly where you are in your journey. You are enough today.",
    tip: "Remind yourself of what you have overcome to get here.",
    modules: [
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "worthless": TertiaryData(
    affirmation: "This feeling is a lie your brain tells you when you are in pain. Your worth is inherent — it cannot be earned and it cannot be lost. Please stay with yourself right now.",
    tip: "Talk to Seviyan for a reminder that you are seen and valued.",
    modules: [
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "insignificant": TertiaryData(
    affirmation: "When the world feels too big, we can feel invisible. But you matter to the people who know you, and your presence changes the room you are in. You take up space, and that is a good thing.",
    tip: "Practicing gratitude helps you reconnect with the world around you.",
    modules: [
      ModuleRef(name: "Gratitude Journal", route: "/gratitude", emoji: "📝"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "excluded": TertiaryData(
    affirmation: "Being left out triggers our deepest survival fears. It hurts immensely. Acknowledge the pain without letting it define your worth. You deserve spaces where you are welcomed.",
    tip: "Connect with Seviyan for a space where you are always welcomed.",
    modules: [
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
    ],
  ),
  "persecuted": TertiaryData(
    affirmation: "Feeling like the world is against you is an exhausting place to be. Whether it is truly external or partly internal, the pain is real. Please talk to someone you trust about what is happening.",
    tip: "An honest conversation — with Seviyan or someone you trust — helps reality-check this feeling.",
    modules: [
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "nervous": TertiaryData(
    affirmation: "Nervousness means something ahead matters to you. That is not a bad sign — it means you care. Channel this energy forward. Preparation and one breath at a time.",
    tip: "Breathing exercises are clinically proven to reduce pre-event nervous system activation.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "exposed": TertiaryData(
    affirmation: "Feeling exposed means your guard came down — whether by choice or not. That vulnerability is not a flaw. It is the cost of being real. Be gentle with yourself while you rebuild.",
    tip: "Gentle, private expression helps you process without further exposure.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),

  // BAD subtree
  "indifferent": TertiaryData(
    affirmation: "Indifference is sometimes protection — when everything has felt too much for too long, the mind steps back. That is okay. You do not have to care about everything right now.",
    tip: "Gentle, low-pressure activities can help you reconnect without forcing it.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
  "apathetic": TertiaryData(
    affirmation: "Apathy often follows a period of over-caring — you gave too much and now there is nothing left. This is your mind asking for rest, not failing. Give yourself genuine rest without guilt.",
    tip: "Rest is not laziness. Your system needs to replenish before you can care again.",
    modules: [
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "pressured": TertiaryData(
    affirmation: "External pressure — from deadlines, people, expectations — compresses you from the outside. Name what is pressuring you, then separate what is actually urgent from what just feels urgent.",
    tip: "Writing out all your pressures and tagging them as real vs perceived reduces the pile significantly.",
    modules: [
      ModuleRef(name: "My Diary", route: "/diary", emoji: "📓"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
  "rushed": TertiaryData(
    affirmation: "Feeling rushed is your body telling you the pace is not sustainable. Something needs to slow down — even briefly. Thirty seconds of actual stillness right now will help more than you expect.",
    tip: "Even one box breathing cycle interrupts the rushed feeling.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "stressed": TertiaryData(
    affirmation: "Stress is your system working too hard for too long. You have been in high gear. Something needs to release — not everything needs a solution right now. Let something out first.",
    tip: "Physical release first — breathing, bursting, scribbling — then think.",
    modules: [
      ModuleRef(name: "Burst It OUT", route: "/burst", emoji: "🗯️"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
    ],
  ),
  "out of control": TertiaryData(
    affirmation: "When everything feels out of control, the most grounding thing you can do is find one tiny thing within your control and do it. Not to fix everything — just to remind yourself you have agency.",
    tip: "The Healing Garden is built exactly for this — small, completable, within your control.",
    modules: [
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Talk to Seviyan", route: "/chat", emoji: "💬"),
    ],
  ),
  "sleepy": TertiaryData(
    affirmation: "Your body is asking for rest — that is not laziness. If you cannot sleep right now, at least give your nervous system something gentle and unstimulating. You have permission to slow all the way down.",
    tip: "Even five minutes of guided stillness helps a tired mind more than scrolling.",
    modules: [
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
    ],
  ),
  "unfocused": TertiaryData(
    affirmation: "An unfocused mind is often an overstimulated one — too many tabs open. You do not need to force focus. Reset first, then return. One thing at a time.",
    tip: "A short breathing reset clears mental clutter faster than trying harder to focus.",
    modules: [
      ModuleRef(name: "Zen Breath Zone", route: "/breathing", emoji: "🌬️"),
      ModuleRef(name: "Mindfulness Studio", route: "/mindfulness", emoji: "🧘"),
      ModuleRef(name: "Healing Garden", route: "/healing-garden", emoji: "🌱"),
    ],
  ),
};

const Map<String, Map<String, List<String>>> emotions = {
  "angry": {
    "let down": ["betrayed", "resentful"],
    "humiliated": ["disrespected", "ridiculed"],
    "bitter": ["indignant", "violated"],
    "mad": ["furious", "jealous"],
    "aggressive": ["provoked", "hostile"],
    "frustrated": ["infuriated", "annoyed"],
    "distant": ["withdrawn", "numb"],
    "critical": ["skeptical", "dismissive"]
  },
  "disgusted": {
    "disapproving": ["judgmental", "embarrassed"],
    "disappointed": ["appalled", "revolted"],
    "awful": ["nauseated", "detestable"],
    "repelled": ["horrified", "hesitant"]
  },
  "sad": {
    "hurt": ["embarrassed", "disappointed"],
    "depressed": ["inferior", "empty"],
    "despair": ["powerless", "grief"],
    "vulnerable": ["fragile", "rejected"],
    "lonely": ["abandoned", "isolated"]
  },
  "happy": {
    "optimistic": ["inspired", "hopeful"],
    "intimate": ["playful", "affectionate"],
    "peaceful": ["loving", "content"],
    "powerful": ["courageous", "creative"],
    "accepted": ["respected", "valued"],
    "proud": ["successful", "confident"],
    "interested": ["curious", "inquisitive"],
    "joyful": ["free", "excited"]
  },
  "surprised": {
    "startled": ["shocked", "dismayed"],
    "confused": ["disillusioned", "perplexed"],
    "amazed": ["awe", "astonished"],
    "excited": ["eager", "energetic"]
  },
  "fearful": {
    "scared": ["helpless", "frightened"],
    "anxious": ["overwhelmed", "worried"],
    "insecure": ["inadequate", "inferior"],
    "weak": ["worthless", "insignificant"],
    "rejected": ["excluded", "persecuted"],
    "threatened": ["nervous", "exposed"]
  },
  "bad": {
    "bored": ["indifferent", "apathetic"],
    "busy": ["pressured", "rushed"],
    "stressed": ["overwhelmed", "out of control"],
    "tired": ["sleepy", "unfocused"]
  }
};
