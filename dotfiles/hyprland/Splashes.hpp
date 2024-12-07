#pragma once
#include <string>
#include <format>
#include <chrono>
#include <vector>

namespace NSplashes {
  inline const std::vector<std::string> SPLASHES = {
      "John 1:1 - In the beginning was the Word, and the Word was with God, and "
      "the Word was God.",
      "John 1:2 - He was in the beginning with God.",
      "John 1:3 - All things were made through him, and without him was not any "
      "thing made that was made.",
      "John 1:4 - In him was life, and the life was the light of men.",
      "John 1:5 - The light shines in the darkness, and the darkness has not "
      "overcome it.",
      "John 1:6 - There was a man sent from God, whose name was John.",
      "John 1:7 - He came as a witness, to bear witness about the light, that "
      "all might believe through him.",
      "John 1:8 - He was not the light, but came to bear witness about the "
      "light.",
      "John 1:9 - The true light, which gives light to everyone, was coming into "
      "the world.",
      "John 1:10 - He was in the world, and the world was made through him, yet "
      "the world did not know him.",
      "John 1:11 - He came to his own, and his own people did not receive him.",
      "John 1:12 - But to all who did receive him, who believed in his name, he "
      "gave the right to become children of God,",
      "John 1:13 - who were born, not of blood nor of the will of the flesh nor "
      "of the will of man, but of God.",
      "John 1:14 - And the Word became flesh and dwelt among us, and we have "
      "seen his glory, glory as of the only Son from the Father, full of grace "
      "and truth.",
      "John 1:15 - (John bore witness about him, and cried out, “This was he of "
      "whom I said, ‘He who comes after me ranks before me, because he was "
      "before me.’”)",
      "John 1:16 - For from his fullness we have all received, grace upon grace.",
      "John 1:17 - For the law was given through Moses; grace and truth came "
      "through Jesus Christ.",
      "John 1:18 - No one has ever seen God; the only God, who is at the "
      "Father’s side, he has made him known.",
      "John 1:19 - And this is the testimony of John, when the Jews sent priests "
      "and Levites from Jerusalem to ask him, “Who are you?”",
      "John 1:20 - He confessed, and did not deny, but confessed, “I am not the "
      "Christ.”",
      "John 1:21 - And they asked him, “What then? Are you Elijah?” He said, “I "
      "am not.” “Are you the Prophet?” And he answered, “No.”",
      "John 1:22 - So they said to him, “Who are you? We need to give an answer "
      "to those who sent us. What do you say about yourself?”",
      "John 1:23 - He said, “I am the voice of one crying out in the wilderness, "
      "‘Make straight the way of the Lord,’ as the prophet Isaiah said.",
      "John 1:24 - (Now they had been sent from the Pharisees.)",
      "John 1:25 - They asked him, “Then why are you baptizing, if you are "
      "neither the Christ, nor Elijah, nor the Prophet?”",
      "John 1:26 - John answered them, “I baptize with water, but among you "
      "stands one you do not know,",
      "John 1:27 - even he who comes after me, the strap of whose sandal I am "
      "not worthy to untie.”",
      "John 1:28 - These things took place in Bethany across the Jordan, where "
      "John was baptizing",
      "John 1:29 - The next day he saw Jesus coming toward him, and said, "
      "“Behold, the Lamb of God, who takes away the sin of the world!",
      "John 1:30 - This is he of whom I said, ‘After me comes a man who ranks "
      "before me, because he was before me.’",
      "John 1:31 - I myself did not know him, but for this purpose I came "
      "baptizing with water, that he might be revealed to Israel.”",
      "John 1:32 - And John bore witness: “I saw the Spirit descend from heaven "
      "like a dove, and it remained on him.",
      "John 1:33 - I myself did not know him, but he who sent me to baptize with "
      "water said to me, ‘He on whom you see the Spirit descend and remain, this "
      "is he who baptizes with the Holy Spirit.’",
      "34 And I have seen and have "
      "borne witness that this is the Son of God.”",
      "John 1:35 - The next day again John was standing with two of his "
      "disciples,",
      "John 1:36 - and he looked at Jesus as he walked by and said, “Behold, the "
      "Lamb of God!”",
      "John 1:37 - The two disciples heard him say this, and they followed "
      "Jesus.",
      "John 1:38 - Jesus turned and saw them following and said to them, “What "
      "are you seeking?” And they said to him, “Rabbi” (which means Teacher), "
      "“where are you staying?”",
      "John 1:39 - He said to them, “Come and you will see.” So they came and "
      "saw where he was staying, and they stayed with him that day, for it was "
      "about the tenth hour.",
      "John 1:40 - One of the two who heard John speak and followed Jesus was "
      "Andrew, Simon Peter’s brother.",
      "John 1:41 - He first found his own brother Simon and said to him, “We "
      "have found the Messiah” (which means Christ).",
      "John 1:42 - He brought him to Jesus. Jesus looked at him and said, “You "
      "are Simon the son of John. You shall be called Cephas” (which means "
      "Peter).",
      "John 1:43 - The next day Jesus decided to go to Galilee. He found Philip "
      "and said to him, “Follow me.”",
      "John 1:44 - Now Philip was from Bethsaida, the city of Andrew and Peter.",
      "John 1:45 - Philip found Nathanael and said to him, “We have found him of "
      "whom Moses in the Law and also the prophets wrote, Jesus of Nazareth, the "
      "son of Joseph.”",
      "John 1:46 - Nathanael said to him, “Can anything good come out of "
      "Nazareth?” Philip said to him, “Come and see.”",
      "John 1:47 - Jesus saw Nathanael coming toward him and said of him, "
      "“Behold, an Israelite indeed, in whom there is no deceit!”",
      "John 1:48 - Nathanael said to him, “How do you know me?” Jesus answered "
      "him, “Before Philip called you, when you were under the fig tree, I saw "
      "you.”",
      "John 1:49 - Nathanael answered him, “Rabbi, you are the Son of God! You "
      "are the King of Israel!”",
      "John 1:50 - Jesus answered him, “Because I said to you, ‘I saw you under "
      "the fig tree,’ do you believe? You will see greater things than these.”",
      "John 1:52 - And he said to him, “Truly, truly, I say to you, you will see "
      "heaven opened, and the angels of God ascending and descending on the Son "
      "of Man.”"};


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
        auto tt    = std::chrono::system_clock::to_time_t(std::chrono::system_clock::now());
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
};
