# -*- coding: utf-8 -*-
"""
Created on Sat Jan 23 03:51:25 2021

@author: 12144
"""

#print "\n".join(klayout.tl.__all__)
#print "\n".join(klayout.db.__all__)
#print "\n".join(klayout.lay.__all__)


import PySimpleGUI as sg 
  
sg.theme('SandyBeach')      
   
layout = [ 
    [sg.Text('Please enter your Xcoord Ycoord')], 
    [sg.Text('Xcoord', size =(15, 1)), sg.InputText()], 
    [sg.Text('Ycoord', size =(15, 1)), sg.InputText()], 
    [sg.Submit(), sg.Cancel()] 
] 
  
window = sg.Window('A* Test', layout) 
event, values = window.read() 
window.close() 
#get Values
xcoord =   values[0]
ycoord =   values[1]

print(event, xcoord, ycoord)    