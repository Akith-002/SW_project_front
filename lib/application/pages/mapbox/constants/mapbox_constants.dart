import 'package:flutter/material.dart';

// --- Constants for Sketch Drawing ---
const int SKETCH_POLYGON_FILL_COLOR = 0x80FFFF80; // Semi-transparent yellow
const int SKETCH_POLYGON_OUTLINE_COLOR = 0xFFFF4444; // Lighter Red
const int SKETCH_LINE_COLOR = 0xFF3366FF; //medim blue color
const int SKETCH_CIRCLE_COLOR = 0xFFFF9933; // Orange
const int TEMP_CIRCLE_CENTER_COLOR = 0xFFAAAAAA; // Grey for temp center marker
const double SKETCH_LINE_WIDTH = 2.5;
const double SKETCH_POLYGON_OUTLINE_WIDTH = 2.0;
const double TAP_CLOSURE_THRESHOLD_PIXELS =
    25.0; // Pixel distance to close polygon

// --- Constants for Initial Lot Drawing ---
const int INITIAL_LOT_FILL_COLOR = 0x800000FF; // Semi-transparent Blue
const int INITIAL_LOT_GUIDE_COLOR = 0xFF448AFF; // Blue Guide
const int INITIAL_LOT_OUTLINE_COLOR = 0xFFFF0000; // Pure red for outline
const double INITIAL_LOT_OUTLINE_WIDTH = 3.5; // Thick outline width
const int POLYGON_VERTEX_DOT_COLOR = 0xFFC2185B; // Hot Pink
const double POLYGON_VERTEX_DOT_RADIUS =5.0; // Blue Guide (If a guide polyline is needed for initial lot)
// Example: Use a distinct green for partition outlines

const int PARTITION_POLYGON_OUTLINE_COLOR = 0xFF3399FF; //medim blue color
const int PARTITION_POLYGON_FILL_COLOR = 0xFFFFD6E1; // Light Pink
 