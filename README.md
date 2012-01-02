Why?
====

For several years now, my brain has been determined to torture me by conciously forcing me to solve small puzzles whenever my brain is temporarily unoccupied. These puzzles include but are not limited to: adding up all of the letters in a word (e.g a+b+c = 6), and organizing a word or sentence into two groups of equal length. I designed this project with the hope that having a computer to perform my impulsive calculations for me will ease my mind's unnecessary work, and may even eventually reverse the problem all together.

What It Does
============

iGroupWords uses text metrics in order to take a word or sentence, and organize it into two even groups of words or characters. By "even," I literally mean that the width in pixels of two groups of words or letters in a particular font are as close as possible. For instance, in the arial font, the letters abc are slightly wider than the letters lil, since l and i are less wide than the letters a, b, or c.

Entering a sentence containing more than two words will automatically trigger iGroupWords' word-by-word grouping, meaning that individual words will not be manipulated, but instead that words will be moved around between groups as a whole in order to make the two groups as even as possible.

Example
=======

Entering the phrase "do you have gum" will result in the output of two groups, one "do have," and the other "you gum." This is an obvious example, because these two strings are the same amount of characters. Although this example is quite trivial to do in one's head, more complicated cases that make heavy use of text metrics can also be solved by iGroupWords.

![Example iGroupWords Screenshot](https://github.com/unixpickle/iGroupWords/raw/master/Example.png)

