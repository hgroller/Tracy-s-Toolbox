# -*- coding: utf-8 -*-
"""
Created on Sun Feb  7 18:30:39 2021

@author: 12144
"""

from pynput.mouse import Listener

def on_move(x, y):
    print('Pointer moved to {0}'.format(
        (x, y)))

def on_click(x, y, button, pressed):
    print('{0} at {1}'.format(
        'Pressed' if pressed else 'Released',
        (x, y)))
    if not pressed:
        # Stop listener
        return False

def on_scroll(x, y, dx, dy):
    print('Scrolled {0}'.format(
        (x, y)))

# Collect events until released
with Listener(
        #on_move=on_move,
        on_click=on_click,
        on_scroll=on_scroll) as listener:
    listener.join()