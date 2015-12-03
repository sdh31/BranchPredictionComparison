#!/bin/bash

javac TwoLevelDataGatherer.java
java TwoLevelDataGatherer ../2LevelData\ gshare
mv TwoLevelGshareData.csv ../
