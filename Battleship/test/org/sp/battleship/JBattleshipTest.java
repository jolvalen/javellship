    /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sp.battleship;

import java.awt.Component;
import java.awt.Container;
import java.awt.Graphics;
import java.awt.Point;
import java.awt.Robot; 
import java.awt.event.InputEvent;
import static java.awt.event.MouseEvent.BUTTON1;
import java.util.concurrent.TimeUnit;
import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Erick
 */
public class JBattleshipTest {
    
    public JBattleship mainFrame; 
     
    
    public void setUpClass() {
        mainFrame = new JBattleship(); 
        mainFrame.setVisible(true);
        mainFrame.setName("mainFrame");
    }
    public void Wait() throws Exception{
        TimeUnit.SECONDS.sleep(1);
    }
    
    
    @Test
    public void runTimeTest(){
        setUpClass(); 
        try{
            Robot robot = new Robot();
                    
            Container content = mainFrame.getContentPane(); 
            
            int mask = InputEvent.getMaskForButton(BUTTON1);
            
            robot.mouseMove(50,50);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            Component[] test = mainFrame.getComponents();
            for(int i = 0; i < test.length; i++){
                System.out.println(test[i]);
                System.out.println(i);
            }
            
            //Make sure the background picture is set to "Checkboard.jpg"
            System.out.println("GetGraphics: " + content.getGraphics());
            assertTrue(content.getGraphics() != null); 
            
            robot.mouseMove(107,202);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            Wait(); 
            
            robot.mouseMove(112,266);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            Wait();
            
            robot.mouseMove(120,333);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            Wait(); 
            
            robot.mouseMove(117,393);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            Wait(); 
            
            robot.mouseMove(237,397);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            Wait(); 
            
            robot.mouseMove(468,215);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait();
            
            robot.mouseMove(497,215);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(535,215);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(561,215);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(585,215);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait();
            
            robot.mouseMove(616,215);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(646,215);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(680,215);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait(); 
            
            ////////////////////ROW 2///////////////////
            robot.mouseMove(470,245);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(500,245);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(526,245);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(562,245);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait(); 
            
            robot.mouseMove(587,245);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(620,245);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(650,245);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(673,245);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait();
            
            /////////////////////ROW 3 //////////////////
            robot.mouseMove(470,275);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(500,275);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(526,275);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(562,275);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait(); 
            
            robot.mouseMove(587,275);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(620,275);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(650,275);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(673,275);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait();
            
            /////////////////////ROW 4 //////////////////
            robot.mouseMove(470,300);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(500,300);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(526,300);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(562,300);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait(); 
            
            robot.mouseMove(587,300);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(620,300);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(650,300);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(673,300);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait();
            
            /////////////////////ROW 5 //////////////////
            robot.mouseMove(470,332);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(500,332);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(526,332);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(562,332);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait(); 
            
            robot.mouseMove(587,332);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(620,332);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(650,332);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(673,332);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait();
            
            /////////////////////ROW 6 //////////////////
            robot.mouseMove(470,365);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(500,365);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(526,365);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(562,365);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait(); 
            
            robot.mouseMove(587,365);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(620,365);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(650,365);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(673,365);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait();
            
            /////////////////////ROW 7 //////////////////
            robot.mouseMove(470,392);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(500,392);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(526,392);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(562,392);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait(); 
            
            robot.mouseMove(587,392);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(620,392);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(650,392);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(673,392);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait();
            
            /////////////////////ROW 8 //////////////////
            robot.mouseMove(470,417);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(500,417);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(526,417);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(562,417);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait(); 
            
            robot.mouseMove(587,417);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(620,417);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait(); 
            robot.mouseMove(650,417);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            
            robot.mouseMove(673,417);
            robot.mousePress(mask);
            robot.mouseRelease(mask);
            //Wait();
            
            assertTrue(mainFrame.isShowing());   
            assertTrue(mainFrame.endPane.isShowing());
            //Wait();
            assertTrue(!mainFrame.isShowing()); 
            
        } catch (Exception awt) {
            int lineNumber = Thread.currentThread().getStackTrace()[2].getLineNumber();
            System.out.println("Caught Exception: " + awt.getLocalizedMessage() + " Line Number: " + lineNumber);    
        }
    }
};
