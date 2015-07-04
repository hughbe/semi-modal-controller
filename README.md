# HBSemiModalNavigationController
A libary that allows you to present a UINavigationController semi modally. Designed modularily, you can create a slideable, zoomable, dismissable and subclassable way of presenting view controllers over other view controllers 

Screenshots
--------------
![alt text](https://github.com/hughbe/SemiModalNavigationController/blob/master/Screenshots/Screenshot1.PNG "Screenshot 1")
![alt text](https://github.com/hughbe/SemiModalNavigationController/blob/master/Screenshots/Screenshot2.PNG "Screenshot 2")

How to setup
--------------
1. Drag out a `UINavigationController` and assign it to a custom `HBSemiModal` class. 
  1. `HBSemiModalNavigationController`: a simple modal way of presenting a `UINavigationController` without a lot of interaction
  2. `HBSlideSemiModalNavigationController`: a modal way of presenting a `UINavigationController` allowing you to drag and change the height of a presented `UINavigationController`. Optionally, you can enable automatic dismissal of the presented controller if needed
  3. `HBZoomSemiModalNavigationController`: a modal way of presenting a `UINavigationController` allowing you to drag and change the height and zoom of a presented `UINavigationController`. Optionally, you can enable automatic dismissal of the presented controller if needed
2. Create a **custom UIStoryboardSegue** to the new `UINavigationController` and assign it to the custom class `HBSemiModalStoryboardSegue`
3. See the demo for more!

Customizability - a lot of this can be done from Interface Builder
--------------
- Change the insets (i.e. the left, right, top and bottom padding) of the presented controller
- Change the minimum and height of the presented controller
- Change the duration of the show and hide animation of the presentation of the controller
- Change the corner radius of the navigation bar of the presented controller
- Enable or disable dragging of the presented controller
- Enable or disabled automatically dismissing the presented controller if it is dragged and dropped past a specific height percentage
- Change the anchor when zooming the presented controller in or out
- Subclass the various `HBSemiModal` classes to change or implement functionality
