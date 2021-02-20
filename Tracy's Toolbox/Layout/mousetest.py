# -*- coding: utf-8 -*-
"""
Created on Mon Feb  8 08:08:49 2021

@author: 12144
"""

from tkinter import *

root = Tk()

def key(event):
    print ("pressed", repr(event.char))

def callback(event):
    print ("clicked at", event.x, event.y)

canvas= Canvas(root, width=100, height=100)
canvas.bind("<Key>", key)
canvas.bind("<Button-1>", callback)
canvas.pack()

root.mainloop()