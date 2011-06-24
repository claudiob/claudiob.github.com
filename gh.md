About
=====

I could tell you one hundred things that shaped my last 31 years. I could list the programming languages I know, those I long to learn, those that never fit in the shape of my mind. I could explain the content of my Ph.D. thesis. I could describe why this page is white and this font is monospaced. I could detail my beliefs over artificial intelligence, gay marriage, the role of bass guitar, the color green and start-up companies. I could overcome you with my obsession on music. I could spell out the underground railway stations of each city I have lived in (including ghost ones). I could show you pictures of the hairstyles I wore in the last decade. I could remember my passion for cyberpunk, my disappointment for virtual reality and how I envision a machine that can help humans be more creative. I could talk about enduring passion, softening precision and nurturing motivation. I could explain how I feed both my rational and my emotional self, spanning from coding to writing, speaking, presenting, telling jokes and (did I mention?) playing music. I could give you doubts, I could challenge you. And then, we should work together.

If you are curious, my mailbox waits for nothing more than your writing.

If you are shy, unveiling some mysteries might give you the energy to overcome your fears.


Boxoffice Script
================

URL
---
http://boxofficescript.com (live preview)

Goal
----
An effective one-page website

Details
-------
My husband is launching an agency that collects original movie scripts from emergent screenwriters, analyzes their viability and offers them to the most appropriate Spanish movie producers. He needs a website that will attract young screenwriters, explain them the agency process and legal terms, and convince them to submit their script.

Technologies
------------
HTML, Javascript

Motivation
----------
Helping my husband's business and experimenting with Javascript

Inspiration
-----------
A one-page site seems a good idea, hence I look at 37signals home-page. Smartly, they organize their message in bullet points, so I apply the same approach, which works greatly on the web.

Graphic design
--------------
As the page takes form, I realize Boxoffice Script needs a logo. Instead of wasting time doing one by myself, I browse some designers' portfolios and hire one of my co-workers. I provide him with a few specifications, and let his creativity work. The basic requirement is that the logo should work both horizontally (spelling out the entire "Boxoffice Script") and bounded within a square (for Twitter icon, Facebook icon, favorites icon). After a couple of weeks he comes back with five draft proposals, I pick one, ask him to refine some proportions and vector shapes, and boom! we have a great logo.

Social awareness
----------------
I develop the site in about a week, but need to wait a month for the lawyer to provide us with legal conditions and contracts. Rather than publishing a 1990-style "Work in progress" banner, I generate expectation in the audience by temporarily showing a blank page with the logo and a form to be contacted once the site launches. I also set up Twitter and Facebook accounts to spread the buzz.

Front-end
---------
Even a web page with a logo and a form can be made more usable with some front-end expedients. The form has two required fields: name and e-mail. By default, they are underlined in red, which turns to green once the content is valid. Also, the "Submit" button remains disabled until both fields are valid. These tricks and the nicely written labels "my name is ... and my e-mail is ..." make error messages redundant and the page slimmer. Form submission is managed through AJAX, so there is no page reloading and the whole experience is more straightforward. Given the small amount of Javascript code needed, I write it myself, instead of using frameworks that would make page loading slower. The entire site also works with Javascript disabled. The Facebook and Twitter social plugins are loaded only after the page has completely loaded, so the page speed score is not affected. As usual, I make sure the entire code validates.

Results
-------
After 3 days, the site has 80 followers in Twitter and 80 "likes" in Facebook. With this number, I can also set up the proper Facebook page name facebook.com/boxofficescript.

Lessons learnt
--------------
* creating expectation in the audience is a good practice, and grants some time to test the page with real users and a small content
* hiring a graphic designer is worth the price; the logo has a great impact on the page that I would not have been able to create by myself.

---

Nodegame
========

URL
---
Not online (yet?)

Goal
----
A multi-purpose game platform where players can invent parts of the game

Details
------
I have studied node.js and web sockets for about a week and I'd like to use these tools to create an online multi-player game in which the players can also edit the world and the rules of the game, thus inventing "new games".

Motivation: learning node.js, observing how people behave when they are given more freedom than in a typical game, generalizing the concept of a video game to learn more about all its components.

Technologies
------------
node.js, Javascript, HTML 5 (canvas)

Inspiration
-----------
I am fascinated by the games that were created in 48 hours at the 2010 Node Knockout event, especially swarmnation and wordsquared. I want to design something like this, but leaving the level design in the hands of players, in a sort of Second Life way. The source code of those games is not available online, so I fall back to another project: wpilot. This game is a node.js remake of the famous xpilot, and I can use its code as a basis to build my project.

Architecture
------------
In the source code of wpilot, all the different game components are heavily tangled, so my first desire is to separate them. I start from the network layer, and refactor the code so that an individual can also play solo without a network connection at all. Then I separate the other components one by one: viewport, world, client, game loop, and so on. I also make sure that the graphics engine is abstracted from the HTML Canvas methods, so that the game can also run on devices other than a web browser.

Results
-------
This project is ongoing, the only evident result so far has been the improvement of my node.js skills.

Lessons learnt
--------------
Diving into node.js requires some time, since its way of organizing code into callbacks is quite different from languages like Ruby and Python. Another hard concept to grasp is how to synchronize different instances of the "same object" on the game server and clients. For instance, every game has only "one" world; however every client creates its own instance by calling "new World", and then the server has to make sure they all represent the same status. It's not as tough as learning LISP, but it's a bit hard to move back and forward from functional languages.

---

CSS waxer
=========

URL
---
http://rubygems.org/gems/csswaxer (as a Ruby gem)

Goal
----
Make stylesheets easier to read and maintain even after months

Details
------
Differently from most people, I group lines by property (typography, color, layout) rather than by selector. In my CSS files, all the font-related properties are group together at the top, followed by colors-related properties, and so on. I have created a command-line tool called csswaxer that transforms any CSS file into a file that follows this style. You can run it by installing rubygems, then typing `gem install csswaxer && csswaxer your_file.css`.

Technologies
------------
CSS, Ruby


Motivation
----------
Grouping styles by property makes the code much easier to manage, even months after it was initially written. If I decide to change the entire "color palette" of a site after one year, I don't have to find the lines where color is used and then isolate the color properties within each selector, as I would do with single-line or multi-line CSS coding style approaches.

Using my approach, I have all the color palette at a glance. The same occurs with font-sizes: when I change the font-size of one element I can immediately see if it becomes smaller or larger than another element. This approach makes style more coherent: I can immediately spot whether two elements have "quite the same color but not", and fix it. The same with padding and margin, I can easily spot whether all the elements are correctly aligned or not.

Inspiration
-----------
My idea of csswaxer is original and is born in reply of a discussion called What's your CSS style? http://forr.st/~uuP born in Forrst. When I shared my point view, listeners pointed me to other ways of creating maintainable CSS code, the most similar to mine being OOCSS https://github.com/stubbornella/oocss

Social awareness
----------------
I always try to make my co-workers aware of my CSS style and get feedback from them. On Forrst http://forr.st/~uX4 I also got 19 likes and 22 comments, but not many followers in GitHub.

Results
-------
Personally, this style achieves my goal to easily maintain code ever years. You can look at the stylesheets of some sites I have deployed and easily get a grasp of its style (and my coding patterns!).

Lessons learnt
--------------
There are no common-ground styling guides for CSS coding, so touching on this key might become a matter of personal tastes. Most people have commented that they "see my point", but are used to a different ordering and are not open to change it. Other developers have moved to CSS frameworks like Less and SASS and manage their code in multiple files. In my opinion, my approach can also work in there, since it focuses on properties more than selectors. The key lesson for me is that properties are more meaningful than selectors, and sometimes I wish what would have happened if the CSS syntax had been reversed from the very beginning, something on the line of:

color:
  white: h1, h3;
  green: h2;
background-color:
  black: h1, h2;
  red: h3;
float:
  left: h1, h2, h3;
  right: h4;
display:
  block: h1, h2, h3;

---

Never fails
===========

URL
---
https://github.com/claudiob/neverfails (just the source code)

Goal
----
Describe what a web application should do and its code will automagically appear

Details
------
Behavior-driven development (BDD) consists of five steps:

1. Describe behavior in plain text
2. Write a step definition
3. Run and watch it fail
4. Write code to make the step pass
5. Run again and see the step pass

Neverfails is a proof of concept to reduce this list to two steps:

1. Describe behaviour in plain text
2. Run and watch it pass

With neverfails, step definitions do not simply check whether the existing code satifies the required behaviour or not. They also write the code to make them pass.

Neverfails involves an ambitious idea: code generation based on specifications. This idea does not depend on a specific platform or programming language. In principle, it could be implemented with any framework. Actually, I have decided to test it using Django as a web framework and Python as the programming language. and Ruby and Rails.

Technologies
------------
Django, lettuce, Python, Ruby, Rails, cucumber, webrat

Motivation
----------
I like the idea of BDD but the point is that I have never met someone actually using, including integration testing. The problem is who should write the specifications, and that varies from company to company. And in the end, you have to repeat the same actions of transforming steps into code again and again. My point of view is new: using the same tools but to build code. In this way, we could give these tools in the hands of everyone.

Inspiration
-----------
When I first got this idea, it sounded strange that no one had ever thought about this, so I navigated online and the only post I could find was one by cowboycoded...

Social awareness
----------------
As this project is still in its early phase, I presented it at as a lightning talk at the LA monthly Django meetup

Results
-------

Lessons learnt
--------------

---

Music Monsters
==============

URL
---
http://musicmonsters.heroku.com/ (live)

Goal
----
Deliver a cool music-related web app in 24 hours

Details
------

Technologies
------------
SVG, Ruby, Rails, music-related APIs

Motivation
----------
Experiment with SVG 

Inspiration
-----------
The only real inspiration was the beer Hannah and I had the night before the Music Hack Day event started. I hadn't even signed up for the event, but luckily I have my friendships in the music-development community :) so I was allowed to join. 

Architecture/Graphic design/Social awareness/Front-end
------------------------------------------------------

Results
-------
We also won an award

Lessons learnt
--------------
Working hard on a problem in a limited amount of time is much more efficient than setting no deadline (or a very remote one). Not only I created a cool application, but I forced myself to overcome my presumed limitations and not to allocate to much time when I couldn't find a solution. The same can be said for the front-end: yes, there are only six monsters, but they are enough to show the idea and to work over. I am really proud of the work done, and my adrenaline is as well. 
The other important lesson is now enriching is to collaborate...

---

Interactive Soundtrack
======================

URL
---
http://rufftrigger.com (just a presentation)
or my MD thesis in Italian

Goal
----
Make a video game more engaging with a soundtrack affected by the game actions.

Details
-------

Technologies
------------
C++, Xbox Audio CT, ..

Motivation
----------
* use AI in a different way in video games
* my love for music-based games
* ...

Inspiration
-----------
Different games.. from Space Invaders to Mark of Kri
Architecture/Graphic design/Social awareness/Front-end
------------------------------------------------------

Results
-------
Not commercial, but I got my Master's degree

Lessons learnt
--------------
* I got to analyze and study music in video games
* Creating the first game for a company is full of highs and lows...

---


