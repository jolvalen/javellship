/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.sp.resources;

import java.awt.*;

/**
 *
 * @author JoseValencia
 */
public class Images {
    public Image load2main(String sRuta){
        return Toolkit.getDefaultToolkit().createImage((getClass().getResource(sRuta)));
    }
}
