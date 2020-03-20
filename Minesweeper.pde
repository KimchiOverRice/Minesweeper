import de.bezier.guido.*;
private static final int NUM_ROWS = 5;
private static final int NUM_COLS = 5;
private boolean lost = false;
private boolean won = false;
private boolean firstPress = false;
private double counter = 0;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    textSize(32);
    frameRate(10);
    // make the manager
    Interactive.make( this );
    
    
    for(int r=0; r<NUM_ROWS; r++){
      for(int c=0; c<NUM_COLS; c++){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    

      setMines();
      setMines();
      setMines();
    
}
public void setMines()
{
   MSButton rando =  buttons[(int)(Math.random()*NUM_ROWS)] [(int)(Math.random()*NUM_COLS)];
   if(mines.isEmpty()){
     mines.add(rando);
     System.out.println(rando.getRow() + " " + rando.getCol());
   }
   else if(!mines.contains(rando)){
     mines.add(rando);
     System.out.println(rando.getRow() + " " + rando.getCol());
   }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int i=0; i<buttons.length; i++){
      for(int j=0; j<buttons[i].length; j++){
       
          if(mines.contains(buttons[i][j]) && !buttons[i][j].flagged){
            return false;
          }
          else if(!mines.contains(buttons[i][j]) && buttons[i][j].flagged){
            return false;
          }
        
      }
    }
    won = true;
    return true;
}
public void displayLosingMessage()
{
    for(int i=0; i<NUM_ROWS; i++){
      for(int j=0; j<NUM_COLS; j++){
        if(mines.contains(buttons[i][j])){
          buttons[i][j].setLabel("x");
        }
      }
    }
    lost = true;
    System.out.println("loser");
}
public void displayWinningMessage()
{
    for(int i=0; i<buttons.length; i++){
      for(int j=0; j<buttons[i].length; j++){
        buttons[i][j].setLabel("0");
       }
     }
    
}
public boolean isValid(int r, int c)
{
    if(r<NUM_ROWS && r>=0 && c<NUM_COLS && c>=0){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i=-1; i<2; i++){
      for(int j=-1; j<2; j++){
        if(isValid(row+i, col+j) && mines.contains(buttons[row+i][col+j])){
          numMines++;
        }
      }
    }
    System.out.println(numMines);
    return numMines;
    
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        firstPress = true;
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          if(this.flagged == false){
            clicked = false;
          }
        }
        else if(mines.contains(this)){
          System.out.println("before");
          displayLosingMessage();
          System.out.println("mines contains this");
        }
        else if(countMines(myRow, myCol)>0){
          this.myLabel = String.valueOf(countMines(myRow, myCol));
        }
        else{
          if(isValid(myRow, myCol-1) && buttons[myRow][myCol-1].clicked == false){
            buttons[myRow][myCol-1].mousePressed();
          }
          if(isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked == false){
            buttons[myRow-1][myCol].mousePressed();
          }
          if(isValid(myRow, myCol+1) && buttons[myRow][myCol+1].clicked == false){
            buttons[myRow][myCol+1].mousePressed();
          }
          if(isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked == false){
            buttons[myRow+1][myCol].mousePressed();
          }
          if(isValid(myRow+1, myCol+1) && buttons[myRow+1][myCol+1].clicked == false){
            buttons[myRow+1][myCol+1].mousePressed();
          }
          if(isValid(myRow-1, myCol-1) && buttons[myRow-1][myCol-1].clicked == false){
            buttons[myRow-1][myCol-1].mousePressed();
          }
            
        }
        
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        textSize(30);
        text(myLabel,x+width/2,y+height/2);
        if(lost){
          pushMatrix();
          textSize(60);
          if((counter%30)== 0)
            text("You Lost", 200, 200);
          
          counter++;
          popMatrix();
        }
        if(won){
          pushMatrix();
          textSize(60);
          fill(140,0,0);
          if((counter%30)== 0)
            text("You Won!", 200, 200);
          
          counter++;
          popMatrix();
        }
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public int getRow(){
      return myRow;
    }
    public int getCol(){
      return myCol;
    }
}
