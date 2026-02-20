#pragma once
#include <chrono>
#include <format>
#include <string>
#include <vector>

namespace NSplashes {
inline const std::vector<std::string> SPLASHES = {
    "1.Q: What is your only comfort in life and death?",
    "That I am not my own, but belong with body and soul, both in life and in "
    "death, to my faithful Saviour Jesus Christ.",
    "He has fully paid for all my sins with His precious blood, and has set me "
    "free from all the power of the devil.",
    "He also preserves me in such a way that without the will of my heavenly "
    "Father not a hair can fall from my head; indeed, all things must work "
    "together for my salvation.",
    "Therefore, by His Holy Spirit He also assures me of eternal life and "
    "makes me heartily willing and ready from now on to live for Him.",
    "2.Q: What do you need to know in order to live and die in the joy of this "
    "comfort?",
    "A: First, how great my sins and misery are; second, how I am delivered "
    "from all my sins and misery; third, how I am to be thankful to God for "
    "such deliverance.",
    "3.Q: From where do you know your sins and misery? A: From the law of God.",
    "4.Q: What does God's law require of us?",
    "A: Christ teaches us this in summary in Matthew 22:37-40: You shall love "
    "the Lord your God with all your heart, and with all your soul, and with "
    "all your mind.",
    "This is the greatest and first commandment. And a second is like it: You "
    "shall love your neighbor as yourself. On "
    "these two commandments hang all the law and the prophets."};

inline const std::vector<std::string> SPLASHES_CHRISTMAS = {
    // clang-format off
        "Merry Christmas!",
        "Merry Xmas!",
        "Ho ho ho",
        "Santa was here",
        "Make sure to spend some jolly time with those near and dear to you!",
        "Have you checked for christmas presents yet?",
    // clang-format on
};

// ONLY valid near new years.
inline static int newYear = []() -> int {
  auto tt =
      std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
  auto local = *localtime(&tt);

  if (local.tm_mon < 8 /* decided with a fair die I promise. */)
    return local.tm_year + 1900;
  return local.tm_year + 1901;
}();

inline const std::vector<std::string> SPLASHES_NEWYEAR = {
    // clang-format off
        "Happy new Year!",
        "[New year] will be the year of the Linux desktop!",
        "[New year] will be the year of the Hyprland desktop!",
        std::format("{} will be the year of the Linux desktop!", newYear),
        std::format("{} will be the year of the Hyprland desktop!", newYear),
        std::format("Let's make {} even better than {}!", newYear, newYear - 1),
    // clang-format on
};
}; // namespace NSplashes
