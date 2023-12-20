# Motivation

I began developing for a highly specialized and extremely technical mixed C++ and Python project
several years ago. Besides two different languages, the project also depends on several large
upstream C++ projects, each of which could take hours to build and install even on multi-core
machines. This naturally led to a solution where a single set of dependencies would be built
and then shared with developers using a networked filesystem (e.g. NFS). This solution had 
several downsides:

1. The entire development environment depended on a networked filesystem that could be slow
   or even completely unresponsive when under heavy load.
2. The environment was extremely delicate and required certain environment variables to have
    the correct values.
3. The environment was almost completely unmovable. Or in other words, if you wished to develop
  on a different computer or cluster, you would need to learn how to compile everything yourself.
4. In order to develop for our project, you needed to also learn how to interact with a cluster
  via the terminal usually meaning you had to learn SSH and a terminal editor like vim or emacs.

All of these downsides led me toward a quest to improve our developer environment with two main
goals in mind: manueverability and user friendliness. Containerization fits the first goal really
well; however, the ease of use of the various container managers leaves a bit to be desired thus
spawning this project.
