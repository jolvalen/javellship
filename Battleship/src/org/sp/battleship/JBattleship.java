/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sp.battleship;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.event.InputEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.awt.event.MouseMotionListener;
import java.util.ArrayList;
import javax.swing.JDialog;
import javax.swing.JOptionPane;
import org.sp.resources.Images;

/**
 *
 * @author Administrador
 */
public class JBattleship extends javax.swing.JFrame {

    Image front;
    Image checkBoard;
    int state=0;

    int myCheckboard[][]=new int[8][8];
    int opponentCheckboard[][]=new int[8][8];
    
    boolean myCheckboardB[][]=new boolean[8][8];
    boolean opponentCheckboardB[][]=new boolean[8][8];

    int placeRow=0;
    int placeCol=0;
    int placeSize=5;
    int placeHor=0;


    //celdaEstaEnTablero
    public boolean validateCoordinate(int row, int col){
        if (row<0) return false;
        if (col<0) return false;
        if (row>=8) return false;
        if (col>=8) return false;
        return true;
    }

    //puedePonerBarco()
    public boolean validateShipCoordiates(int tab[][], int size, int row, int col, int hor){
        int diffRow=0,diffCol=0;
        if (hor==1) diffRow=1;
        else diffCol=1;
        for (int c2=col;c2<=col+size*diffCol;c2++){
            for (int f2=row;f2<=row+size*diffRow;f2++){
                if (!validateCoordinate(f2, c2)){
                    return false;
                }
            }
        }
        for (int f2=row-1;f2<=row+1+diffRow*size;f2++){
            for (int c2=col-1;c2<=col+1+diffCol*size;c2++){
                if (validateCoordinate(f2,c2)){
                    if (tab[f2][c2]!=0){
                        return false;
                    }
                }
            }
        }
        return true;
    }

    public void placeShip(int tab[][], int size){

        int row,col,hor;
        do{
            row=(int)(Math.random()*8);
            col=(int)(Math.random()*8);
            hor=(int)(Math.random()*2);
        }while(!validateShipCoordiates(tab, size, row, col, hor));
        int diffRow=0,diffCol=0;
        if (hor==1) diffRow=1;
        else diffCol=1;
        for (int f2=row;f2<=row+(size-1)*diffRow;f2++){
            for (int c2=col;c2<=col+(size-1)*diffCol;c2++){
                tab[f2][c2]=size;
            }
        }
    }

    public void start(){
        for (int i=0;i<8;i++){
            for (int j=0;j<8;j++){
                myCheckboard[i][j]=0;
                opponentCheckboard[i][j]=0;
                myCheckboardB[i][j]=false;
                opponentCheckboardB[i][j]=false;
            }
        }
        for (int size=5;size>=1;size--){ //loop to build 5 ships, each of diff size
            placeShip(opponentCheckboard, size);
        }
        placeSize=5;
    }


    public void checkShipAfterMouseClick(){
        int pDF=0;
        int pDC=0;
        if (placeHor==1){
            pDF=1;
        }else{
            pDC=1;
        }
        if (placeRow+placeSize*pDF>=8){
            placeRow=7-placeSize*pDF;
        }
        if (placeCol+placeSize*pDC>=8){
            placeCol=7-placeSize*pDC;
        }
    }

    public boolean validateShipCoordiates(){
        return validateShipCoordiates(myCheckboard, placeSize, placeRow, placeCol, placeHor);
    }

    public boolean checkVictory(int tab[][], boolean bTab[][]){
        for (int i=0;i<8;i++){
            for (int j=0;j<8;j++){
                if (bTab[i][j]==false && tab[i][j]!=0){
                    return false;
                }
            }
        }
        return true;
    }

    // This function chooses a random square in the checkboard and fires
    public void shootAI(){
        int row,col;
        do{
            row=(int)(Math.random()*8);
            col=(int)(Math.random()*8);
        }while(myCheckboardB[row][col]==true);
        myCheckboardB[row][col]=true;
    }
    
    /** Creates new form JBattleship */
    public JBattleship() {
        Images i =new Images();
        front=i.load2main("front.jpg");
        checkBoard=i.load2main("checkboard.jpg");
        initComponents();
        setBounds(0,0,1211,644);
        addMouseListener(
            new MouseAdapter() {
                public void mouseClicked(MouseEvent e) {
                    if (e.getModifiers() == MouseEvent.BUTTON3_MASK && state==1){
                        placeHor=1-placeHor;
                        checkShipAfterMouseClick();
                        repaint();
                        return;
                    }
                    if (state==0){
                        state=1;
                        start();
                        repaint();
                    }else if (state==1){
                        if (validateShipCoordiates()){
                            int pDF=0;
                            int pDC=0;
                            if (placeHor==1){
                                pDF=1;
                            }else{
                                pDC=1;
                            }
                            for (int m=placeRow;m<=placeRow+(placeSize-1)*pDF;m++){
                                for (int n=placeCol;n<=placeCol+(placeSize-1)*pDC;n++){
                                    myCheckboard[m][n]=placeSize;
                                }
                            }
                            placeSize--;
                            if (placeSize==0){
                                state=2;
                                repaint();
                            }
                        }
                    }else if (state==2){
                        int f=(e.getY()-200)/30;
                        int c=(e.getX()-450)/30;
                        if (f!=placeRow || c!=placeCol){
                            placeRow=f;
                            placeCol=c;
                            if (validateCoordinate(f, c)){
                                if (opponentCheckboardB[f][c]==false){
                                    opponentCheckboardB[f][c]=true;
                                    repaint();
                                    if (checkVictory(opponentCheckboard, opponentCheckboardB)){
                                        JOptionPane.showMessageDialog(null, "You've won! Congratulations");
                                        state=0;
                                    }
                                    shootAI();
                                    repaint();
                                    if (checkVictory(myCheckboard, myCheckboardB)){
                                        JOptionPane.showMessageDialog(null, "You've Lost, better luck next time");
                                        state=0;
                                    }
                                    repaint();
                                }
                            }
                        }
                    }
                }
            }
        );
        addMouseMotionListener(
            new MouseMotionAdapter() {
                @Override
                public void mouseMoved(MouseEvent e) {
                    int x=e.getX();
                    int y=e.getY();
                    if (state==1 && x>=106 && y>=200 && x<106+30*8 && y<200+30*8){
                        int f=(y-200)/30;
                        int c=(x-106)/30;
                        if (f!=placeRow || c!=placeCol){
                            placeRow=f;
                            placeCol=c;
                            checkShipAfterMouseClick();
                            repaint();
                        }
                    }
                }
            }
        );
    }

    public boolean missShot(int tab[][], int valor, boolean bVisible[][]){
        for (int n=0;n<8;n++){
            for (int m=0;m<8;m++){
                if (bVisible[n][m]==false){
                    if (tab[n][m]==valor){
                        return false;
                    }
                }
            }
        }
        return true;
    }

    public void paintCheckboard(Graphics g, int tab[][], int x, int y, boolean bVisible[][]){
        for (int n=0;n<8;n++){
            for (int m=0;m<8;m++){
                if (tab[n][m]>0 && bVisible[n][m]){
                    g.setColor(Color.yellow);
                    if (missShot(tab, tab[n][m], bVisible)){
                        g.setColor(Color.red);
                    }
                    g.fillRect(x+m*30, y+n*30, 30, 30);
                }
                if (tab[n][m]==0 && bVisible[n][m]){
                    g.setColor(Color.cyan);
                    g.fillRect(x+m*30, y+n*30, 30, 30);
                }
                if (tab[n][m]>0 && tab==myCheckboard && !bVisible[n][m]){
                    g.setColor(Color.gray);
                    g.fillRect(x+m*30, y+n*30, 30, 30);
                }
                g.setColor(Color.black);
                g.drawRect(x+m*30, y+n*30, 30, 30);
                if (state==1 && tab==myCheckboard){
                    int pDF=0;
                    int pDC=0;
                    if (placeHor==1){
                        pDF=1;
                    }else{
                        pDC=1;
                    }
                    if (n>=placeRow && m>=placeCol && n<=placeRow+(placeSize-1)*pDF && m<=placeCol+(placeSize-1)*pDC){
                        g.setColor(Color.green);
                        g.fillRect(x+m*30, y+n*30, 30, 30);
                    }
                }
            }
        }
    }

    boolean bPrimeraVez=true;
    public void paint(Graphics g){
        if (bPrimeraVez){
            g.drawImage(front, 0,0,1,1,this);
            g.drawImage(checkBoard, 0,0,1,1,this);
            bPrimeraVez=false;
        }
        if (state==0){
            g.drawImage(front, 0, 0, this);
        }else {
            setBounds(0,0,800,600);
            g.drawImage(checkBoard, 0, 0, this);
            paintCheckboard(g, myCheckboard, 106, 200, myCheckboardB);
            paintCheckboard(g, opponentCheckboard, 454, 200, opponentCheckboardB);
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 400, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 300, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new JBattleship().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables
}
