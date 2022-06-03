/*   Ralph Sabatino
     Kord: An Educational Music Game
     CITA 495 - Final Capstone Project
     Summer 2016
*/


// _________________________ IMPORTS _______________________________________________

import themidibus.*; // Import my two external libraries: The MidiBus, and SoundCipher
import arb.soundcipher.*;

//_______________________ GAME OBJECTS AND VARIABLES _______________________________

SoundCipher sc = new SoundCipher(this); // Create objects for my libraries
MidiBus myBus;

PFont f; // Needed for fonts

color primTextCol = #FFE100; // Colors to be used for texts, buttons, and checkboxes
color secTextCol = #FFFFFF;
color altTextCol = #2BFF3D;
color primButCol = #56BADB;
color secButCol = #66D9FF;
color primCheckCol = #FFE100;
color secCheckCol = #FFFBD9;

IntList pressedKeys; // Intlists for keeping track of what keys are pressed and which notes (represented by ints) are in the given chord
IntList myChordNotes;

String[] triadTypes = {"Maj", "min", "dim", "Aug"}; // Possible triads types
String[] seventhTypes = {"Maj", "min", "", "dim", "halfdim", "minMaj", "Aug"}; // Possible 7th chord types

String[] sharpScale = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}; // Chromatic scale with sharps
String[] flatScale = {"C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"}; // Chromatic scale with flats

String[] myCourses = {"Triad Chords", "7th Chords", "Triad Chord Inversions", "7th Chord Inversions", "Triad Lead-Sheet", "7th Lead-Sheet"};
String[] myDiffs = {"Easy", "Medium", "Hard", "Pro"};
String[] myModes = {"Five Lives", "Timed"};

String message = ""; // Strings for displaying information
String addPointsTxt = "";

String inv1 = ""; // Strings for representing inversion
String inv2 = "";

String leadBass = "";

int curCourse = 0; // Which course is seleced ( 0 = Triads, 1 = 7th Chords, etc... )
int curDiff = 0; // The difficulty ( 0 = Easy, 1 = Medium, 2 = Hard, 3 = Pro )
int curPage = 0; // 0 = Main Menu, 1 = Play (choose lesson, difficulty), 2 = Options, 3 = Profiles, 4 = Scores, 5  = Gameplay
int curMode = 0; // 0 = Five Lives, 1 = Timed

boolean hasAnswered = true; // A boolean so we can check if the player has answered yet
boolean isRight = false;
boolean firstQ = true;

MyPiano myPiano = new MyPiano(); // Create my piano object, only need one
Triad curTriad; // A triad which can be accessed from anywhere (for now)
Seventh curSeventh;

Cannon[] myCans = new Cannon[5];
Block[] myBlocks = new Block[5];

float timeLeft = 20.0; // Variables for gameplay and scorekeeping
float posScore = 1000.0;
int curScore = 0;

int myLives = 5;
float myTime = 120.0;
float challengeTime = 20.0;
float timeLasted = 0.0;

int mouseOverBut = 0; // Moar variables
int reqKeys = 3;

int testing = 0;

float corNum = 0.0; // Vars keeping track of amount answered wrongly or right
float wrongNum = 0.0;

String[] alph = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}; // Vars for submitting intials for high scores

int char1 = 0, char2 = 0, char3 = 0;
int curChar = 0;


void setup(){ // ______________________ SETUP ___________________
  
  size(1280,720);
  background(100);
  frameRate(10);
  
  f = createFont("Arial", 50, true);
  
  MidiBus.list();
  myBus = new MidiBus(this, 1, 4); // New MidiBus object connecting to the MIDI
  
  pressedKeys = new IntList();
  myChordNotes = new IntList();
  
  for(int i=0;i<5;i++){ // Setting up an array for my cannons
    myCans[i] = new Cannon(0, 550, 20);
  }
  
  for(int i=0;i<5;i++){ // Setting up an array for my falling blocks
    myBlocks[i] = new Block(0, 150, -1);
  }
  
}

void draw(){ // _________________________________________________ MAIN DRAW() FUNCTION ____________________________________________________________
  
  
  
  switch(curPage){ // Our switch statement for keeping track of the current page. (0 = Main Menu, 1 = Play Choice Menu, etc...)
    
    case 0: // _____________ MAIN MENU _________________________
      background(100); // Keep the background grey
      
      stroke(0);
      fill(primTextCol);
      textFont(f,50);
      text("KORD", 570, 100);
      textFont(f, 30);
      textAlign(CENTER);
      text("An educational music game.", 640, 150);
      textAlign(LEFT);
      textFont(f, 50);
      fill(primButCol);
      strokeWeight(2);
      for(int i = 0; i<3; i++){
        fill(primButCol);
        if(mouseOverBut == i+1){
          fill(secButCol);
        }
        rect(540, 200+(i*100), 200, 50);
      }
      fill(255);
      textFont(f,40);
      text("Play", 600, 240);
      text("Options", 570, 340);
      textFont(f, 30);
      text("HighScores", 560, 435);
      
      textAlign(RIGHT);
      text("Developed by Ralph Sabatino IV", 1270, 710);
      textAlign(LEFT);
      
      break;
      
      case 1: // ______________ PLAY CHOICE MENU _____________________
        background(100); // Keep the background grey
        
        textFont(f,50);
        fill(primTextCol);
        text("PLAY", 570, 100);
        
        fill(altTextCol);
        text("Courses", 100, 200);
        text("Difficulty", 600, 200);
        text("Mode", 900, 200);
        
        fill(secTextCol);
        textFont(f,30);
        text("3-Voice Chords (Triads)", 100, 250);
        text("4-Voice Chords (7th Chords)", 100, 300);
        text("Triad Inversions", 100, 350);
        text("7th Chord Inversions", 100, 400);
        text("Triad Lead-Sheet Symbols", 100, 450);
        text("7th Chord Lead-Sheet Symbols", 100, 500);
        
        text("Easy", 600, 250);
        text("Medium", 600, 300);
        text("Hard", 600, 350);
        text("Pro", 600, 400);
        
        text("Five Lives", 900, 250);
        text("Timed", 900, 300);
        
        
        for(int i=0; i<6; i++){ // Checkboxes for the course
          if(curCourse == i){
            fill(primCheckCol);
          }
          else{
            fill(secCheckCol);
          }
          rect(35, 220+(i*50), 40, 40);
        }
        
        for(int i=0; i<4; i++){ // Checkboxes for the difficulty
          if(curDiff == i){
            fill(primCheckCol);
          }
          else{
            fill(secCheckCol);
          }
          rect(535, 220+(i*50), 40, 40);
        }
        
        for(int i=0; i<2; i++){ // Checkboxes for the mode
          if(curMode == i){
            fill(primCheckCol);
          }
          else{
            fill(secCheckCol);
          }
          rect(835, 220+(i*50), 40, 40);
        }
        
    
        
        if(mouseOverBut == 1){
          fill(secButCol);
        }
        else{
          fill(primButCol);
        }
        rect(10, 10, 200, 50);
        
        if(mouseOverBut == 2){
          fill(secButCol);
        }
        else{
          fill(primButCol);
        }
        rect(1070, 660, 200, 50);
        
        fill(secTextCol);
        textFont(f,50);
        text("Back", 55, 55);
        text("Go!", 1135, 705);
        
        break;
        
      case 2: // ______________________ OPTIONS MENU __________________________
        background(100); // Keep the background grey
        
        textFont(f,50);
        fill(primTextCol);
        text("OPTIONS", 570, 100);
        
        fill(primButCol);
        if(mouseOverBut == 1){
          fill(secButCol);
        }
        rect(10, 10, 200, 50);
        
        fill(secTextCol);
        text("Back", 55, 55);
        
        break;
        
      case 3: // _______________________ HIGH SCORE CHOICE MENU __________________________
        
        background(100); // Keep the background grey
        
        textFont(f,50);
        fill(primTextCol);
        text("Check Highscores", 440, 100);
        
        fill(altTextCol);
        text("Courses", 100, 200);
        text("Difficulty", 600, 200);
        text("Mode", 900, 200);
        
        fill(secTextCol);
        textFont(f,30);
        text("3-Voice Chords (Triads)", 100, 250);
        text("4-Voice Chords (7th Chords)", 100, 300);
        text("Triad Inversions", 100, 350);
        text("7th Chord Inversions", 100, 400);
        text("Triad Lead-Sheet Symbols", 100, 450);
        text("7th Chord Lead-Sheet Symbols", 100, 500);
        
        text("Easy", 600, 250);
        text("Medium", 600, 300);
        text("Hard", 600, 350);
        text("Pro", 600, 400);
        
        text("Five Lives", 900, 250);
        text("Timed", 900, 300);
        
        
        for(int i=0; i<6; i++){ // Checkboxes for the course
          if(curCourse == i){
            fill(primCheckCol);
          }
          else{
            fill(secCheckCol);
          }
          rect(35, 220+(i*50), 40, 40);
        }
        
        for(int i=0; i<4; i++){ // Checkboxes for the difficulty
          if(curDiff == i){
            fill(primCheckCol);
          }
          else{
            fill(secCheckCol);
          }
          rect(535, 220+(i*50), 40, 40);
        }
        
        for(int i=0; i<2; i++){ // Checkboxes for the mode
          if(curMode == i){
            fill(primCheckCol);
          }
          else{
            fill(secCheckCol);
          }
          rect(835, 220+(i*50), 40, 40);
        }
        
    
        
        if(mouseOverBut == 1){
          fill(secButCol);
        }
        else{
          fill(primButCol);
        }
        rect(10, 10, 200, 50);
        
        if(mouseOverBut == 2){
          fill(secButCol);
        }
        else{
          fill(primButCol);
        }
        rect(1070, 660, 200, 50);
        
        fill(secTextCol);
        textFont(f,50);
        text("Back", 55, 55);
        text("Check", 1100, 705);
        
        break;
        
      case 4: // ______________________ HIGH SCORE DISPLAY __________________________
        readData(myModes[curMode], myDiffs[curDiff], myCourses[curCourse]);
        
        strokeWeight(2);
        
        fill(primButCol);
        if(mouseOverBut == 1){
          fill(secButCol);
        }
        rect(10, 10, 200, 50);
        
        fill(secTextCol);
        text("Back", 55, 55);
        
        break;
        
        
      case 5: // _______________________ GAMEPLAY _______________________________
      
        if(myLives < 1 || myTime < .1){ // If we lose all of our lives or if total time runs out, change to the end game screen
          curPage = 11;
          break;
        }
        background(100); // Keep the background grey
        
        stroke(0);
        strokeWeight(2);
        fill(primButCol); // Pause button
        if(mouseOverBut == 1){
          fill(secButCol);
        }
        rect(10, 10, 200, 50);
        
        textFont(f, 50);
        fill(secTextCol);
        text("Pause", 45, 55);
        
        
        textFont(f, 20); // Displays information regarding the current course and difficulty
        fill(primTextCol);
        text("Course: ", 1000, 25);
        text("Difficulty: ", 990, 50);
        text("Mode: ", 1015, 75);
        fill(secTextCol);
        text(myCourses[curCourse], 1075, 25);
        text(myDiffs[curDiff], 1075, 50);
        text(myModes[curMode], 1075, 75);
        
        if(curDiff < 3){ // If we're not on Pro difficulty, draw the piano
          myPiano.draw(); // Draws the piano
        }
        else{ // If we don't draw the piano, draw a line where the top of it would be
          strokeWeight(4);
          stroke(255);
          line(0, 550, 1280, 550);
        }
        
        for(int u = 0; u<myBlocks.length; u++){ // Draws my falling blocks. Only the active blocks will be drawn though (this is built in the Block's draw() function)
          myBlocks[u].draw();
        }
        
        if(hasAnswered == true){ // We check to see if the player has answered yet, and if so, we create a new challenge for them, but only after our animations are done
        
          if(myCans[0].isFiring == false && myBlocks[0].isExploding == false){ // We wait for our animations to finish, and if they are, we reset everything for a new question
          
            // Based on the course we create a new random chord
            if(curCourse == 0){ // Triad Chords
              curTriad = new Triad(12+int(random(25)), triadTypes[int(random(4))], 0, int(random(2))); // Creates a new randomized triad
              myChordNotes = curTriad.getNotes(); // Uses the pitches, represnted at ints, to be used in my code
            }
            else if(curCourse == 1){ // Seventh Chords
              curSeventh = new Seventh(12+int(random(25)), seventhTypes[int(random(7))], 0, int(random(2)));
              myChordNotes = curSeventh.getNotes();
            }
            else if(curCourse == 2 || curCourse == 4){ // Triad Inversions
              curTriad = new Triad(12+int(random(25)), triadTypes[int(random(4))], int(random(3)), int(random(2))); // Creates a new randomized triad
              myChordNotes = curTriad.getNotes(); // Uses the pitches, represnted at ints, to be used in my code
            }
            else if(curCourse == 3 || curCourse == 5){ // Seventh Inversions
              curSeventh = new Seventh(12+int(random(25)), seventhTypes[int(random(7))], int(random(4)), int(random(2)));
              myChordNotes = curSeventh.getNotes();
            }
            
            hasAnswered = false;
            
            if(firstQ){
              firstQ = false;
            }
            else{
              delay(4000); // We delay 4 seconds in between challenges
            }
            
            pressedKeys.clear(); // Clears the Intlist just in case any info gets stuck in the gameplay
            
            message = ""; // Reset variables and feed myPiano a new triad
            timeLeft = challengeTime;
            posScore = 1000.0;
            myPiano.setChord(myChordNotes);
            
            for(int i = 0; i<myCans.length; i++){ // Reset cannons for next question
              myCans[i].setActive(false);
            }
            
            for(int k = 0; k < myChordNotes.size(); k++){ /// Reset my blocks for next question
              myBlocks[k].reset(myChordNotes.get(k));
            }
          }
          
          else{ // If the animations are still iterating
          
            for(int i = 0; i<myBlocks.length; i++){
              if(myBlocks[i].active && !myBlocks[i].isExploding){ // We go through our blocks and check to see if they are active and NOT exploding
                boolean tempBool = myBlocks[i].checkFire(myCans[0].firePos); // We check if the bullets hit the blocks, and tempBool returns true or false (makes block explode in checkFire if the bullet hits the block)
                if (tempBool){ // If the blocks have been hit
                  for(int j = 0; j<myCans.length; j++){
                    myCans[j].setActive(false); // We stop the cannons from firing, and the bullets (and cannon) stop being drawn
                  }
                }
              }
            }
            
          }
          
        } // End of if(hasAnswered == true) ________________________
        
        else if(timeLeft <= 0.0){ // If the player hasnt answered yet but time ran out
          message = "Time ran out!";
          curScore -= 500;
          hasAnswered = true;
          timeLeft = 0.0;
          posScore = 0.0;
          wrongNum++;
        }
        
        else if(hasAnswered == false){ // If the player hasn't answered yet, but there is still time left in the challenge
          
          if(pressedKeys.size() == reqKeys){ // We wait for the player to press enough keys to represent a chord (3 in the case of a triad, 4 for seventh) before checking anything
          
            pressedKeys.sort(); // Since keys are added to the IntList based on which key is pressed first, we must sort it, from lowest to highest
            
            if(myChordNotes.get(0)%12 == pressedKeys.get(0)%12 && myChordNotes.get(1)%12 == pressedKeys.get(1)%12 && myChordNotes.get(2)%12 == pressedKeys.get(2)%12){ // If the keys pressed are correct
              if(reqKeys == 4){
                if(myChordNotes.get(3)%12 == pressedKeys.get(3)%12){
                  isRight = true;
                }
              }
              else{
                isRight = true;
              }
            }
            else{
              isRight = false;
            }
              
            if(isRight){
              corNum++;
              
              for(int i = 0; i<myCans.length; i++){ // We go through our cannons and fire them (if they are active)
                if(myCans[i].active == true){
                  myCans[i].fire();
                  myBlocks[i].setPitch(pressedKeys.get(i)); // Make it so whatever octave of the chord is pressed, the falling icicles/blocks will be there
                  myBlocks[i].falling = true;
                }
              }
              
              message = "Correct!"; // Display that they are correct, add points to their score
              curScore += int(posScore);
                
              
              if(reqKeys == 4){
                float[] pitches = {pressedKeys.get(0)+24, pressedKeys.get(1)+24, pressedKeys.get(2)+24, pressedKeys.get(3)+24};
                sc.playChord(pitches, 90, 8); // Play the chord
              }
              else{
                float[] pitches = {pressedKeys.get(0)+24, pressedKeys.get(1)+24, pressedKeys.get(2)+24};
                sc.playChord(pitches, 90, 8); // Play the chord
              }
              
            }
            else{
              wrongNum++;
              
              message = "Wrong!";
              curScore -= int(posScore);
            }
            
            hasAnswered = true;
              
          }
            
        } // End of if(hasAnswered == false) _______________
          
        if(timeLeft>0 && hasAnswered == false){ // Keep counting down time and possible score while the player hasn't answered yet
          timeLeft -= .1;
          timeLasted += .1;
          if(curMode == 1){
            myTime -= .1;
          }
          posScore -= (1000/challengeTime)/10;
        }
        
        
        if(message == "Correct!"){ // Change fill color and update the score based on the 3 outcomes (correct, wrong, time ran out)
          fill(0, 255, 0);
          addPointsTxt = "+" + int(posScore);
        }
        else if(message == "Wrong!"){
          fill(255, 0, 0);
          addPointsTxt = "-" + int(posScore);
          if(curMode == 0){ myLives--; }
        }
        else if(message == "Time ran out!"){
          fill(255, 0, 0);
          addPointsTxt = "-500";
          if(curMode == 0){ myLives--; }
        }
        else{
          addPointsTxt = "";
        }
        
        textFont(f, 80);
        text(message, 425, 180); // Actually display the message
        
        textFont(f, 30);
        text(addPointsTxt, 1150, 140); // Displays the points added or subtracted to total score from the question
        
        textFont(f, 50);
        fill(primTextCol);
        textAlign(RIGHT);
        if(curCourse == 0 || curCourse == 2){
          text(curTriad.toString(), 640, 50); // Displays the current representation of the challenge
        }
        else if(curCourse == 1 || curCourse == 3){
          text(curSeventh.toString(), 640, 50);
        }
        else if(curCourse == 4){
          text(curTriad.toLeadString(), 640, 50);
        }
        else if(curCourse == 5){
          text(curSeventh.toLeadString(), 640, 50);
        }
        
        textAlign(LEFT);
        textFont(f, 20);
        text(inv1, 650, 30); // displays the inversion numbers
        text(inv2, 650, 50);
        
        if(leadBass != ""){ // displays the bass if lead-sheet
          textFont(f, 40);
          text(leadBass, 565, 110);
          stroke(255);
          line(475, 65, 675, 65);
        }
        
        textFont(f, 30);
        text("Possible Points:", 10, 100); // Static texts
        text("Time Left:", 80, 140);
        
        text("Current Score:", 950, 110);
        
        if(curMode == 0){ // If we're in five lives mode
          text("Lives:", 220, 50);
        }
        else{ // Or else we're in endless mode
          text("Total Time:", 220, 50);
        }
        
        fill(secTextCol); // Displays the variables for the texts displayed above
        text(int(posScore), 225, 100);
        text(nf(timeLeft, 2, 1), 225, 140);
        text(curScore, 1150, 110);
        
        if(curMode == 0){
          text(myLives, 300, 50);
        }
        else{
          text(int(myTime) + " sec", 365, 50);
        }
        
        
        for(int i = 0; i<myCans.length; i++){ // Simply draws the cannons if they're active
          if(myCans[i].active == true){
            myCans[i].draw();
          }
        }
        
        break;
        
      case 10: // ________________ PAUSE SCREEN _____________________________
        fill(0);
        stroke(255);
        rect(440, 210, 400, 300);
        fill(255);
        textFont(f, 30);
        text("PAUSED", 580, 250);
        
        fill(primButCol);
        if(mouseOverBut == 1){
          fill(secButCol);
        }
        rect(540, 300, 200, 50);
        fill(primButCol);
        if(mouseOverBut == 2){
          fill(secButCol);
        }
        rect(540, 380, 200, 50);
        
        fill(255);
        textFont(f, 50);
        text("Resume", 550, 342);
        text("Quit", 590, 422);
        
        break;
        
      case 11: // _____________________ END GAME SCREEN _____________________________
      
        fill(0);
        stroke(255);
        rect(240, 110, 800, 500);
        
        fill(secButCol);
        textFont(f, 40);
        text("Lesson Over", 510, 160);
        
        fill(primButCol);
        if(mouseOverBut == 1){ fill(secButCol); }
        rect(830, 550, 200, 50);
        fill(255);
        text("OK!", 895, 590);
        
        fill(primTextCol);
        textAlign(RIGHT);
        text("Total Score:", 630, 220);
        if(curMode == 0){
          text("Time Lasted:", 630, 270);
        }
        else{
          text("Questions Answered:", 630, 270);
        }
        
        fill(secTextCol);
        textAlign(LEFT);
        text(curScore, 650, 220);
        if(curMode == 0){
          text(int(timeLasted) + " sec", 650, 270);
        }
        else{
          text(int(corNum+wrongNum), 650, 270);
        }
        

        if(curScore<0){
          message = "You need to practice.";
        }
        else if(curScore < 5000){
          message = "You could use more practice.";
        }
        else if(curScore < 10000){
          message = "Not Bad.";
        }
        else if(curScore < 15000){
          message = "Good job!";
        }
        else{
          message = "Excellent! How about something tougher?";
        }
        
        fill(255);
        textAlign(CENTER);
        text(message, 640, 330);
        
        text(int(100*(corNum/(corNum+wrongNum))) + "%", 640, 380);
        
        if(checkScore(myModes[curMode], myDiffs[curDiff], myCourses[curCourse], curScore)){ // If we have a new highscore
          fill(secButCol);
          text("New Highscore! Enter your initials.", 640, 450);
          
          if(curChar == 0){
            fill(primTextCol);
          }
          else{
            fill(secTextCol);
          }
          text(alph[char1], 540, 530);
          
          if(curChar == 1){
            fill(primTextCol);
          }
          else{
            fill(secTextCol);
          }
          text(alph[char2], 640, 530);
          
          if(curChar == 2){
            fill(primTextCol);
          }
          else{
            fill(secTextCol);
          }
          text(alph[char3], 740, 530);
          
        }
        
        textAlign(LEFT);
        
        break;
        
      case 15: // _______________________________ COUNTDOWN SCREEN ________________________
        
        background(100);
        textFont(f, 100);
        fill(0, 255, 40);
        textAlign(CENTER);
        if(testing < 10){
          text("3", 640, 360);
        }
        else if(testing < 20){
          text("2", 640, 360);
        }
        else if(testing < 30){
          text("1", 640, 360);
        }
        else{
          curPage = 5;
          testing = 0;
          break;
        }
        testing ++;
        
        break;
        
        
  }   
    
}

// ________________________________ MOUSE EVENTS ______________________________________________

void mouseMoved(){ // Events that happen when the mouse is moved, like changing colors when hovering over a button
  
  switch(curPage){
    
    case 0: // Main Menu
      if(mouseX >= 540 && mouseX <= 740 && mouseY >= 200 && mouseY <= 250){
        mouseOverBut = 1;
      }
      else if(mouseX >= 540 && mouseX <= 740 && mouseY >= 300 && mouseY <= 350){
        mouseOverBut = 2;
      }
      else if(mouseX >= 540 && mouseX <= 740 && mouseY >= 400 && mouseY <= 450){
        mouseOverBut = 3;
      }
      else if(mouseX >= 540 && mouseX <= 740 && mouseY >= 500 && mouseY <= 550){
        mouseOverBut = 4;
      }
      else{
        mouseOverBut = 0;
      }
      break;
    
    case 1: // Play Choice Menu   rect(1055, 645, 200, 50);
      if(mouseX >= 10 && mouseX <= 210 && mouseY >= 10 && mouseY <= 60){
        mouseOverBut = 1;
      }
      else if(mouseX >= 1070 && mouseX <= 1270 && mouseY >= 660 && mouseY <= 710){
        mouseOverBut = 2;
      }
      else{
        mouseOverBut = 0;
      }
      break;
      
    case 2: // Options Menu
      if(mouseX >= 10 && mouseX <= 210 && mouseY >= 10 && mouseY <= 60){
        mouseOverBut = 1;
      }
      else{
        mouseOverBut = 0;
      }
      break;
      
    case 3: // Highscore Choice Menu
      if(mouseX >= 10 && mouseX <= 210 && mouseY >= 10 && mouseY <= 60){
        mouseOverBut = 1;
      }
      else if(mouseX >= 1070 && mouseX <= 1270 && mouseY >= 660 && mouseY <= 710){
        mouseOverBut = 2;
      }
      else{
        mouseOverBut = 0;
      }
      break;
        
    case 4: // Highscore Display
      if(mouseX >= 10 && mouseX <= 210 && mouseY >= 10 && mouseY <= 60){
        mouseOverBut = 1;
      }
      else{
        mouseOverBut = 0;
      }
      break;
        
    case 5: // Gameplay
      if(mouseX >= 10 && mouseX <= 210 && mouseY >= 10 && mouseY <= 60){
        mouseOverBut = 1;
      }
      else{
        mouseOverBut = 0;
      }
      break;
      
    case 10: // Pause Menu
      if(mouseX >= 540 && mouseX <= 740 && mouseY >= 300 && mouseY <= 350){
        mouseOverBut = 1;
      }
      else if(mouseX >= 540 && mouseX <= 740 && mouseY >= 380 && mouseY <= 430){
        mouseOverBut = 2;
      }
      else{
        mouseOverBut = 0;
      }
      break;
      
    case 11: // End Game Screen
      if(mouseX >= 830 && mouseX <= 1030 && mouseY >= 550 && mouseY <= 600){
        mouseOverBut = 1;
      }
      else{
        mouseOverBut = 0;
      }
      break;
    
  }
  
  
  
}

void mouseReleased(){ // Do something when the mouse is clicked
  
  
  switch(curPage){
    
    case 0: // Main Menu
      if(mouseOverBut == 1){
        curPage = 1;
      }
      else if(mouseOverBut == 2){
        curPage = 2;
      }
      else if(mouseOverBut == 3){
        curPage = 3;
      }
      break;
      
    case 1: // Play Choice Menu
      if(mouseOverBut == 1){
        curPage = 0;
        break;
      }
      else if(mouseOverBut == 2){
        curPage = 15;
        break;
      }
      
      if(mouseX >= 35 && mouseX <= 75 && mouseY >= 220 && mouseY <= 260){
        curCourse = 0;
        reqKeys = 3;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 270 && mouseY <= 310){
        curCourse = 1;
        reqKeys = 4;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 320 && mouseY <= 360){
        curCourse = 2;
        reqKeys = 3;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 370 && mouseY <= 410){
        curCourse = 3;
        reqKeys = 4;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 420 && mouseY <= 460){
        curCourse = 4;
        reqKeys = 3;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 470 && mouseY <= 510){
        curCourse = 5;
        reqKeys = 4;
      }
      
      if(mouseX >= 535 && mouseX <= 575 && mouseY >= 220 && mouseY <= 260){
        curDiff = 0;
        challengeTime = 20.0;
      }
      else if(mouseX >= 535 && mouseX <= 575 && mouseY >= 270 && mouseY <= 310){
        curDiff = 1;
        challengeTime = 15.0;
      }
      else if(mouseX >= 535 && mouseX <= 575 && mouseY >= 320 && mouseY <= 360){
        curDiff = 2;
        challengeTime = 11.0;
      }
      else if(mouseX >= 535 && mouseX <= 575 && mouseY >= 370 && mouseY <= 410){
        curDiff = 3;
        challengeTime = 8.0;
      }
      
      if(mouseX >= 835 && mouseX <= 875 && mouseY >= 220 && mouseY <= 260){
        curMode = 0;
      }
      else if(mouseX >= 835 && mouseX <= 875 && mouseY >= 270 && mouseY <= 310){
        curMode = 1;
      }
      
      break;
      
      
    case 2: // Options Menu
      if(mouseOverBut == 1){
        curPage = 0;
      }
      break;
      
    case 3: // High Score Choice Menu
      if(mouseOverBut == 1){
        curPage = 0;
        break;
      }
      else if(mouseOverBut == 2){
        curPage = 4;
        break;
      }
      
      if(mouseX >= 35 && mouseX <= 75 && mouseY >= 220 && mouseY <= 260){
        curCourse = 0;
        reqKeys = 3;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 270 && mouseY <= 310){
        curCourse = 1;
        reqKeys = 4;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 320 && mouseY <= 360){
        curCourse = 2;
        reqKeys = 3;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 370 && mouseY <= 410){
        curCourse = 3;
        reqKeys = 4;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 420 && mouseY <= 460){
        curCourse = 4;
        reqKeys = 3;
      }
      else if(mouseX >= 35 && mouseX <= 75 && mouseY >= 470 && mouseY <= 510){
        curCourse = 5;
        reqKeys = 4;
      }
      
      if(mouseX >= 535 && mouseX <= 575 && mouseY >= 220 && mouseY <= 260){
        curDiff = 0;
        challengeTime = 20.0;
      }
      else if(mouseX >= 535 && mouseX <= 575 && mouseY >= 270 && mouseY <= 310){
        curDiff = 1;
        challengeTime = 15.0;
      }
      else if(mouseX >= 535 && mouseX <= 575 && mouseY >= 320 && mouseY <= 360){
        curDiff = 2;
        challengeTime = 11.0;
      }
      else if(mouseX >= 535 && mouseX <= 575 && mouseY >= 370 && mouseY <= 410){
        curDiff = 3;
        challengeTime = 8.0;
      }
      
      if(mouseX >= 835 && mouseX <= 875 && mouseY >= 220 && mouseY <= 260){
        curMode = 0;
      }
      else if(mouseX >= 835 && mouseX <= 875 && mouseY >= 270 && mouseY <= 310){
        curMode = 1;
      }
      
      break;
        
    case 4: // Highscore Display
      if(mouseOverBut == 1){
        curPage = 3;
      }
      break;
        
    case 5: // Gameplay
      if(mouseOverBut == 1){
        curPage = 10;
      }
      break;
      
    case 10: // Pause Menu
      if(mouseOverBut == 1){
        curPage = 5;
      }
      else if(mouseOverBut == 2){
        curPage = 0;
        resetVars(); // We reset the vars for when we quit midgame or end game and go back to main screen
      }
      break;
      
    case 11: // End Game Screen
      if(mouseOverBut == 1){
        
        saveData(myModes[curMode], myDiffs[curDiff], myCourses[curCourse], alph[char1]+alph[char2]+alph[char2], curScore);
        
        curPage = 0;
        resetVars(); // We reset the vars for when we quit midgame or end game and go back to main screen
      }
      break;
    
  }

  
}

//  _______________________________ MIDI HANDLING _______________________________

void noteOn(Note note) { // When we receive a noteOn from the MIDI keyboard

  //println("Channel:"+note.channel());
  //println("Pitch:"+note.pitch());
  //println("Velocity:"+note.velocity());
  
  switch(curPage){
    
    case 5: // Gameplay
      pressedKeys.append(note.pitch);
      //println(pressedKeys);
      
      for(int i = 0; i<myCans.length; i++){ // Finds the first cannon not in use, sets it to active and gives it a pitch to calculate it's X pos with
        if(myCans[i].active == false){
          myCans[i].setPitch(note.pitch);
          myCans[i].setActive(true);
          i = myCans.length;
        }
      }
      break;
      
    case 11: // End Game Screen
      if(note.channel() == 9){
        if(curChar < 2){
          curChar++;
        }
        else{
          curChar = 0;
        }
      }
      else{
        if(curChar == 0){
          if(char1 < 25){
            char1++;
          }
          else{
            char1 = 0;
          }
        }
        else if(curChar == 1){
          if(char2 < 25){
            char2++;
          }
          else{
            char2 = 0;
          }
        }
        else{
          if(char3 < 25){
            char3++;
          }
          else{
            char3 = 0;
          }
        }
      }
      
      break;
    
  }
  
  
  
}

void noteOff(Note note) { // When we receive a noteOff from the MIDI
  
  //println("Channel:"+note.channel());
  //println("Pitch:"+note.pitch());
  //println("Velocity:"+note.velocity());
  
  for(int i = 0; i < pressedKeys.size(); i++)  { // Go through pressedKeys and remove the key that's not longer pressed
    
    if(pressedKeys.get(i)==note.pitch()){
      pressedKeys.remove(i);
      
      for(int j = 0; j<myCans.length; j++){ // Deactivate the cannon
        if(myCans[j].notePitch == note.pitch && myCans[j].isFiring == false){
          myCans[j].setActive(false);
          myCans[j].setPitch(-1);
        }
      }

    }
    
  }
  //println(pressedKeys);
}

// ___________________________Delays the thread by a certain number of milliseconds. 1000 ms = 1 second __________________________
void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}


// ________________________ CLASSES _____________________________________________________________

// ___Triad chord class
class Triad {
  
  int rootNote, inversion, acc;
  String type;
  
  Triad(int RN, String T, int I, int A) {
    rootNote = RN;
    type = T;
    inversion = I;
    acc = A;
  }
  
  IntList getNotes(){
    IntList tempNotes = new IntList();
    tempNotes.append(rootNote);
    if(type == "Maj"){
      tempNotes.append(rootNote + 4);
      tempNotes.append(rootNote + 7);
    }
    else if(type == "min"){
      tempNotes.append(rootNote + 3);
      tempNotes.append(rootNote + 7);
    }
    else if(type == "dim"){
      tempNotes.append(rootNote + 3);
      tempNotes.append(rootNote + 6);
    }
    else if(type == "Aug"){
      tempNotes.append(rootNote + 4);
      tempNotes.append(rootNote + 8);
    }
    
    if(inversion == 1){
      tempNotes.add(0, 12);
    }
    else if(inversion == 2){
      tempNotes.add(0, 12);
      tempNotes.add(1, 12);
    }
    tempNotes.sort();
    
    return tempNotes;
  }
  
  String toString(){
    String myString;
    if(acc == 0){
      myString = sharpScale[rootNote%12] + " " + type;
    }
    else{
      myString = flatScale[rootNote%12] + " " + type;
    }
    if(inversion == 1){
      inv1 = "6";
      inv2 = "";
    }
    else if(inversion == 2){
      inv1 = "6";
      inv2 = "4";
    }
    else{
      inv1 = "";
      inv2 = "";
    }
    return myString;
  }
  
  String toLeadString(){
    String myString;
    if(acc == 0){
      myString = sharpScale[rootNote%12] + " " + type;
      leadBass = sharpScale[this.getNotes().get(0)%12];
    }
    else{
      myString = flatScale[rootNote%12] + " " + type;
      leadBass = flatScale[this.getNotes().get(0)%12];
    }
    return myString;
  }
  
}

// ___Seventh chord class
class Seventh {
  
  int rootNote, inversion, acc;
  String type, form;
  
  Seventh(int RN, String T, int I, int A) {
    rootNote = RN;
    type = T;
    inversion = I;
    acc = A;
  }
  
  IntList getNotes(){
    IntList myNotes = new IntList();
    myNotes.append(rootNote);
    if(type == "Maj"){
      myNotes.append(rootNote + 4);
      myNotes.append(rootNote + 7);
      myNotes.append(rootNote + 11);
    }
    else if(type == "min"){
      myNotes.append(rootNote + 3);
      myNotes.append(rootNote + 7);
      myNotes.append(rootNote + 10);
    }
    else if(type == ""){
      myNotes.append(rootNote + 4);
      myNotes.append(rootNote + 7);
      myNotes.append(rootNote + 10);
    }
    else if(type == "dim"){
      myNotes.append(rootNote + 3);
      myNotes.append(rootNote + 6);
      myNotes.append(rootNote + 9);
    }
    else if(type == "halfdim"){
      myNotes.append(rootNote + 3);
      myNotes.append(rootNote + 6);
      myNotes.append(rootNote + 10);
    }
    else if(type == "minMaj"){
      myNotes.append(rootNote + 3);
      myNotes.append(rootNote + 7);
      myNotes.append(rootNote + 11);
    }
    else if(type == "Aug"){
      myNotes.append(rootNote + 4);
      myNotes.append(rootNote + 8);
      myNotes.append(rootNote + 11);
    }
    return myNotes;
  }
  
  String toString(){
    String myString;
    if(acc == 0){
      myString = sharpScale[rootNote%12] + " " + type;
    }
    else{
      myString = flatScale[rootNote%12] + " " + type;
    }
    if(inversion == 1){
      inv1 = "6";
      inv2 = "5";
    }
    else if(inversion == 2){
      inv1 = "4";
      inv2 = "3";
    }
    else if(inversion == 3){
      inv1 = "4";
      inv2 = "2";
    }
    else{
      inv1 = "7";
      inv2 = "";
    }
    return myString;
  }
  
  String toLeadString(){
    String myString;
    if(acc == 0){
      myString = sharpScale[rootNote%12] + " " + type;
      leadBass = sharpScale[this.getNotes().get(0)%12];
    }
    else{
      myString = flatScale[rootNote%12] + " " + type;
      leadBass = flatScale[this.getNotes().get(0)%12];
    }
    inv1 = "7";
    inv2 = "";
    return myString;
  }
  
}

class MyPiano { // Class to represent the piano which will show in all difficulties except for the toughest one
  
  IntList chordNotes = new IntList();
  IntList myWhites = new IntList();
  IntList myAccs = new IntList();
  int[] whites = {0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23, 24, 26, 28, 29, 31, 33, 35, 36, 38, 40, 41, 43, 45, 47, 48, 50, 52, 53, 55, 57, 59, 60};
  int[] accidentals = {1, 3, 6, 8, 10, 13, 15, 18, 20, 22, 25, 27, 30, 32, 34, 37, 39, 42, 44, 46, 49, 51, 54, 56, 58};
  
  MyPiano(){
    
    for(int i=0; i<whites.length; i++){
      myWhites.append(whites[i]);
    }
    for(int i=0; i<accidentals.length; i++){
      myAccs.append(accidentals[i]);
    }
    
  }
  
  void draw(){
    
    fill(255);
    stroke(0);
    strokeWeight(2);
    
    int whiteCount = 0;
    int blackCount = 0;
    
    for(int i=0; i<61; i++){ // Draw the white keys
      
      if(myWhites.hasValue(i)){
        
        if(chordNotes.hasValue(i) && curDiff < 2){ // If the note is in the chord, highlight it red
          fill(255, 0, 0);
        }
        else{
          fill(255);
        }
        
        rect(8+(35*whiteCount), 550, 35, 165);
        whiteCount++;
      }
      
    }
    
    for(int i=0; i<61; i++){ // Draw the accidental keys
      
      fill(0);
      if(myAccs.hasValue(i)){
        if(i == 6 || i == 13 || i == 18 || i == 25 || i == 30 || i == 37 || i == 42 || i == 49 || i == 54){ // On a keyboard there is more whites than accidentals so we occasional skip over a space
          blackCount++;
        }
        
        if(chordNotes.hasValue(i) && curDiff < 2){  // If the note is in the chord, highlight it blue
          fill(0, 0, 255);
        }
        else{
          fill(0);
        }
        
        rect(35+(35*blackCount), 550, 17, 110);
        blackCount++;
      }
      
    }
    
  }
  
  void setChord(IntList xChord){  //  Changes what chord to represent on the piano.
    chordNotes = xChord;    
  }
  
}


class Cannon{ // A triangle represents a cannon
  
  int BPX, BPY, size, iteration = 0, notePitch = -1, firePos; // BPX = Base Point X
  boolean isFiring = false, active = false;
  
  Cannon(int PX, int PY, int S){
    BPX = PX;
    BPY = PY;
    size = S;
  }
  
  void draw(){
    if(active == true){
      stroke(0);
      fill(0, 255, 0);
      strokeWeight(2);
      triangle(BPX, BPY, BPX+(size/2), BPY-size, BPX+size, BPY);
      
      if(isFiring == true){
        stroke(255, 255, 100);
        firePos = BPY-size-(iteration*20)-20;
        line(BPX+(size/2), firePos+20, BPX+(size/2), firePos);
        iteration++;
      }
    }
    
    
  }
  
  void fire(){
    isFiring = true;
  }
  
  void setX(int XP){
    BPX = XP;
  }
  
  void setActive(boolean A){
    active = A;
    isFiring = false;
    iteration = 0;
  }
  
  void setPitch(int P){
    notePitch = P;
    BPX = 8+int(20.416*notePitch);
  }
  
}


class Block{ // Class for falling blocks
  
  int XP, notePitch, iter;
  float YP;
  boolean active = false, isExploding = false, falling = false;
  
  Block(int X, int Y, int P){
    XP = X;
    YP = float(Y);
    notePitch = P;
  }
  
  void draw(){
    if(active){
      if(falling){
        fill(#BAEEFF);
        strokeWeight(2);
        stroke(#5ED7FF);
        YP = 150 + (iter * 20);
        rect(XP, YP, 20, 50);
        iter++;
      }
      else if(isExploding){
        stroke(255, 255-(iter*15), 0);
        strokeWeight(4);
        fill(255, iter*15, 0);
        ellipse(XP+10, YP+20, 20+(iter*6), 20+(iter*6));
        iter++;
        if(iter > 15){
          isExploding = false;
          active = false;
        }
      }
      else if(curDiff < 3){
        fill(#BAEEFF);
        strokeWeight(2);
        stroke(#5ED7FF);
        YP = 148 + random(4);
        rect(XP-2+random(2), YP, 20, 50);
        
        rect(XP-2+random(2)-(int(20.416*12)), YP, 20, 50);
        rect(XP-2+random(2)-(int(20.416*24)), YP, 20, 50);
        rect(XP-2+random(2)-(int(20.416*36)), YP, 20, 50);
        
        rect(XP-2+random(2)+(int(20.416*12)), YP, 20, 50);
        rect(XP-2+random(2)+(int(20.416*24)), YP, 20, 50);
        rect(XP-2+random(2)+(int(20.416*36)), YP, 20, 50);
        
      }
      
    }
    
  }
  
  void setPitch(int P){
    notePitch = P;
    XP = 8+int(20.416*notePitch);
  }
  
  void setActive(boolean A){
    active = A;
    iter=0;
  }
  
  void explode(){
    iter = 0;
    falling = false;
    isExploding = true;
  }
  
  void reset(int P){
    iter = 0;
    active = true;
    isExploding = false;
    this.setPitch(P);
    falling = false;
  }
  
  boolean checkFire(int F){
    if(YP >= F-65){
      this.explode();
      return true;
    }
    else{
      return false;
    }
  }
  
}

void resetVars(){ // So we can reset variables, that way things dont get messed up or stuck, glitch out, etc...
  
  pressedKeys.clear();
  myChordNotes.clear();
  
  message = "";
  addPointsTxt = "";
  
  inv1 = "";
  inv2 = "";
  
  leadBass = "";
  
  curCourse = 0; // Which course is seleced ( 0 = Triads, 1 = 7th Chords, etc... )
  curDiff = 0; // The difficulty ( 0 = Easy, 1 = Medium, 2 = Hard, 3 = Pro )
  curPage = 0; // 0 = Main Menu, 1 = Play (choose lesson, difficulty), 2 = Options, 3 = Profiles, 4 = Scores, 5  = Gameplay
  curMode = 0; // 0 = Five Lives, 1 = Timed
  
  hasAnswered = true; // A boolean so we can check if the player has answered yet
  isRight = false;
  firstQ = true;
  
  timeLeft = 20.0; // Variables for gameplay and scorekeeping
  posScore = 1000.0;
  curScore = 0;
  
  myLives = 5;
  myTime = 120.0;
  challengeTime = 20.0;
  timeLasted = 0.0;
  
  mouseOverBut = 0; // Moar variables
  reqKeys = 3;
  testing = 0;
  
  for(int i = 0; i < 5; i++){
    myCans[i].setActive(false);
    myBlocks[i].setActive(false);
  }
  
  corNum = 0.0;
  wrongNum = 0.0;
  
}

// _________________________________ DATA READING AND WRITING ________________________________

void saveData(String M, String D, String C, String N, int S){ // Saves a highscore into our text file
  
  String[] myNames = {"AAA", "AAA", "AAA", "AAA", "AAA"};
  String[] myScores = {"000", "000", "000", "000", "000"};
  
  String[] temp, temp2;
  String[] myLines = loadStrings("myData.txt");
  
  boolean done = false;
  
  for(int i = 0; i<myLines.length; i++){
    temp = split(myLines[i], ":");
    
    if(temp[0].equals(M)){
      temp = split(temp[1], "#");
      
      if(temp[0].equals(D)){
        temp = split(temp[1], "!");
        
        if(temp[0].equals(C)){
          temp = split(temp[1], ",");
          
          for(int j = 0; j<temp.length; j++){
            temp2 = split(temp[j], " ");
            myNames[j] = temp2[0];
            myScores[j] = temp2[1];
          }
          
          for(int j = 0; j<myScores.length; j++){
            if(!done){
              if(int(S) > int(myScores[j])){
                for(int k = myScores.length-1; k >= j; k--){
                  if(k == j){
                    myNames[k] = N;
                    myScores[k] = Integer.toString(S);
                    myLines[i] = M + ":" + D + "#" + C + "!";
                    for(int q = 0; q < myNames.length; q++){
                      if(q != 0){
                        myLines[i] += ",";
                      }
                      myLines[i] += myNames[q] + " " + myScores[q];
                    }
                    saveStrings("myData.txt", myLines);
                    done = true;
                  }
                  else{
                    myNames[k] = myNames[k-1];
                    myScores[k] = myScores[k-1];
                    
                  }
                }
              }
            }
            
          }
          
        }
        
      }
      
    }
    
  }
  
}

void readData(String M, String D, String C){ // Reads and displays the highscores
  String[] myNames = {"AAA", "AAA", "AAA", "AAA", "AAA"};
  String[] myScores = {"000", "000", "000", "000", "000"};
  
  String[] myLines = loadStrings("myData.txt");
  String[] temp, temp2;
  
  for(int i = 0; i<myLines.length; i++){
    temp = split(myLines[i], ":");
    
    if(temp[0].equals(M)){
      temp = split(temp[1], "#");
      
      if(temp[0].equals(D)){
        temp = split(temp[1], "!");
        
        if(temp[0].equals(C)){
          temp = split(temp[1], ",");
          
          for(int j = 0; j<temp.length; j++){
            temp2 = split(temp[j], " ");
            myNames[j] = temp2[0];
            myScores[j] = temp2[1];
          }
          
          background(100);
          fill(primTextCol);
          textAlign(CENTER);
          text("Highscores", 640, 50);
          
          stroke(0);
          strokeWeight(5);
          line(20, 175, 1260, 175);
          
          fill(secButCol);
          textAlign(LEFT);
          text(M, 20, 150);
          textAlign(CENTER);
          text(D, 640, 150);
          textAlign(RIGHT);
          text(C, 1260, 150);
          textAlign(LEFT);
          for(int k = 0; k<myNames.length; k++){
            if(k == 0){
              fill(218*1.2,165*1.2,32*1.2);
            }
            else if(k == 1){
              fill(192*1.2,192*1.2,192*1.2);
            }
            else{
              fill(205*1.2,127*1.2,50*1.2);
            }
            text(myNames[k], 20, 250+100*k);
            fill(secTextCol);
            text(myScores[k], 640, 250+100*k);
          }
          
        }
        
      }
      
    }
    
  }
  
}

boolean checkScore(String M, String D, String C, int S){ // Check to see if we have a new highscore or not
  boolean bool = false;
  
  String[] myScores = {"000", "000", "000", "000", "000"};
  String[] temp, temp2;
  
  String[] myLines = loadStrings("myData.txt");
  
  for(int i = 0; i<myLines.length; i++){
    temp = split(myLines[i], ":");
    
    if(temp[0].equals(M)){
      temp = split(temp[1], "#");
      
      if(temp[0].equals(D)){
        temp = split(temp[1], "!");
        
        if(temp[0].equals(C)){
          temp = split(temp[1], ",");
          
          for(int j = 0; j<temp.length; j++){
            temp2 = split(temp[j], " ");
            myScores[j] = temp2[1];
          }

          
        }
        
      }
      
    }
    
  }
  
  if(S > int(myScores[myScores.length-1])){
    bool = true;
  }
  
  return bool;
}
