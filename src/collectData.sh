#!/bin/bash

javac TwoLevelDataGatherer.java
java TwoLevelDataGatherer ../2LevelData/
mv TwoLevelData.csv ../
