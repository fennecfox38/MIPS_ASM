# MIPS_ASM

Simple examples written in MIPS Assembly

## Development Environment: [MARS(MIPS Assembly and Runtime Simulator)](https://courses.missouristate.edu/kenvollmar/mars/)

![](https://courses.missouristate.edu/kenvollmar/mars/NavOneColumn_files/CarrLftStrUnivRev.gif)

![](https://courses.missouristate.edu/kenvollmar/mars/Mars%20140.jpg)

**Download ```Mars4_5.jar``` from [here](https://courses.missouristate.edu/kenvollmar/mars/MARS_4_5_Aug2014/Mars4_5.jar)**

## Install Java SE Runtime Environment and set up Environment Variable

Java SE Runtime Environment (JRE) is required to execute ```Mars4_5.jar```

Try to run ```java --version``` and install JRE if it is not install.

[Download JRE](https://www.java.com/en/download/)
or execute command ```sudo apt install openjdk-17-jre```

For Windows, set up Java Environment Variable to use java binary globally.
Refer [Stack Overflow](https://stackoverflow.com/questions/1672281/environment-variables-for-java-installation)

## Using MARS from a command line.
  ```java -jar mars.jar [options] program.asm [more files...] [ pa arg1 [more args...]]```

Read [Document](https://courses.missouristate.edu/kenvollmar/mars/Help/Help_4_1/MarsHelpCommand.html) for detail

## Executing MARS GUI

execute ```java -jar Mars4_5.jar``` in the directory where ```Mars4_5.jar``` at

Read [Document](https://courses.missouristate.edu/kenvollmar/mars/Help/Help_4_1/MarsHelpIDE.html) for detail

## Multi-file project assembly

Put all project files in the project directory and define the main procedure globally and enable the following options in GUI (parenthesis for CLI)

- 'Settings' - 'Assemble all files in directory' (option ```p``` for CLI)
- 'Settings' - 'Initialize Program Counter to global 'main' if defined' (option ```sm``` for CLI)

eg.) ```java -jar Mars4_5.jar p sm DGEMM/DGEMM.asm```
