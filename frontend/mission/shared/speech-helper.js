window.mobileSpeechHelper = (() => {
  const supportsSpeech = "speechSynthesis" in window;
  const isMobileDevice = /android|iphone|ipad|ipod/i.test(navigator.userAgent);
  let voicesPromise = null;
  let speechPrimed = false;
  let hasUserGesture = false;

  function markUserGesture() {
    hasUserGesture = true;
  }

  window.addEventListener("pointerdown", markUserGesture, { passive: true });
  window.addEventListener("touchstart", markUserGesture, { passive: true });
  window.addEventListener("keydown", markUserGesture, { passive: true });

  async function loadVoices() {
    if (!supportsSpeech) return [];

    const voices = speechSynthesis.getVoices();
    if (voices.length) return voices;

    if (!voicesPromise) {
      voicesPromise = new Promise(resolve => {
        let finished = false;
        const finish = () => {
          if (finished) return;
          finished = true;
          resolve(speechSynthesis.getVoices());
        };

        const handleVoicesChanged = () => {
          clearTimeout(voiceTimeout);
          finish();
        };

        const voiceTimeout = setTimeout(() => {
          speechSynthesis.removeEventListener("voiceschanged", handleVoicesChanged);
          finish();
        }, 1200);

        speechSynthesis.addEventListener("voiceschanged", handleVoicesChanged, { once: true });
      });
    }

    return voicesPromise;
  }

  function findVoice(language, fallbackLanguages = []) {
    if (!supportsSpeech) return null;

    const voices = speechSynthesis.getVoices();
    const languages = [language, ...fallbackLanguages];

    for (const candidate of languages) {
      const exactVoice = voices.find(voice => voice.lang === candidate);
      if (exactVoice) return exactVoice;
    }

    for (const candidate of languages) {
      const languageRoot = candidate.split("-")[0].toLowerCase();
      const partialVoice = voices.find(voice => voice.lang.toLowerCase().startsWith(languageRoot));
      if (partialVoice) return partialVoice;
    }

    return null;
  }

  async function primeMobileSpeech() {
    if (!supportsSpeech) return false;

    await loadVoices();

    try {
      speechSynthesis.resume();
    } catch (error) {
      // Ignore resume failures and continue with best effort speech playback.
    }

    if (speechPrimed || !isMobileDevice) {
      speechPrimed = true;
      return true;
    }

    return new Promise(resolve => {
      let settled = false;
      const finish = ready => {
        if (settled) return;
        settled = true;
        speechPrimed = ready || speechPrimed;
        resolve(ready);
      };

      const primer = new SpeechSynthesisUtterance(".");
      primer.lang = "en-US";
      primer.volume = 0;
      primer.rate = 1;
      primer.pitch = 1;
      primer.onend = () => finish(true);
      primer.onerror = () => finish(false);

      try {
        speechSynthesis.cancel();
        speechSynthesis.speak(primer);
        setTimeout(() => finish(false), 1200);
      } catch (error) {
        finish(false);
      }
    });
  }

  function createUtterance(text, language, options = {}) {
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = language;
    utterance.rate = options.rate ?? 1;
    utterance.pitch = options.pitch ?? 1;

    const voice = language.startsWith("ko")
      ? findVoice("ko-KR", ["ko"])
      : findVoice("en-US", ["en-GB", "en"]);

    if (voice) {
      utterance.voice = voice;
    }

    return utterance;
  }

  async function speakText(text, language, options = {}) {
    if (!supportsSpeech) {
      return { ok: false, reason: "unsupported" };
    }

    if (isMobileDevice && !hasUserGesture && !options.requireGesture) {
      return { ok: false, reason: "gesture-required" };
    }

    await loadVoices();

    try {
      speechSynthesis.resume();
    } catch (error) {
      // Ignore resume failures and continue with best effort speech playback.
    }

    if (options.prime) {
      await primeMobileSpeech();
    } else {
      speechPrimed = true;
    }

    return new Promise(resolve => {
      let settled = false;
      const finish = result => {
        if (settled) return;
        settled = true;
        resolve(result);
      };

      const utterance = createUtterance(text, language, options);
      utterance.onend = () => finish({ ok: true });
      utterance.onerror = () => finish({ ok: false, reason: "error" });

      try {
        speechSynthesis.cancel();
        setTimeout(() => {
          try {
            speechSynthesis.speak(utterance);
            setTimeout(() => {
              try {
                speechSynthesis.resume();
              } catch (error) {
                // Ignore resume failures after speech has started.
              }
            }, 120);
          } catch (error) {
            finish({ ok: false, reason: "error" });
          }
        }, 40);
        setTimeout(() => finish({ ok: false, reason: "timeout" }), 10000);
      } catch (error) {
        finish({ ok: false, reason: "error" });
      }
    });
  }

  return {
    hasUserGesture: () => hasUserGesture,
    isMobileDevice,
    supportsSpeech,
    speakText
  };
})();
