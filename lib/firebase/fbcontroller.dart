
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zelix_kingdom/models/city.dart';
import 'package:zelix_kingdom/models/factory.dart';
import 'package:zelix_kingdom/models/product.dart';

class Fbcontroller {
  List<Map<String, dynamic>> products = [
      {
        "name": "Iron Ore",
        "level": 1,
        "purchasePrice": 100,
        "salePrice": 105,
        "duration": 300,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Copper Ore",
        "level": 1,
        "purchasePrice": 120,
        "salePrice": 126,
        "duration": 320,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Coal",
        "level": 1,
        "purchasePrice": 60,
        "salePrice": 63,
        "duration": 250,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Limestone",
        "level": 1,
        "purchasePrice": 70,
        "salePrice": 73.5,
        "duration": 260,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Sand",
        "level": 1,
        "purchasePrice": 80,
        "salePrice": 84,
        "duration": 200,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Water",
        "level": 1,
        "purchasePrice": 10,
        "salePrice": 10.5,
        "duration": 100,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Clay",
        "level": 1,
        "purchasePrice": 65,
        "salePrice": 68.25,
        "duration": 220,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Sulfur",
        "level": 1,
        "purchasePrice": 75,
        "salePrice": 78.75,
        "duration": 240,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Nickel",
        "level": 1,
        "purchasePrice": 90,
        "salePrice": 94.5,
        "duration": 270,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Zinc",
        "level": 1,
        "purchasePrice": 85,
        "salePrice": 89.25,
        "duration": 280,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Graphite",
        "level": 1,
        "purchasePrice": 95,
        "salePrice": 99.75,
        "duration": 290,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Gypsum",
        "level": 1,
        "purchasePrice": 55,
        "salePrice": 57.75,
        "duration": 230,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Salt",
        "level": 1,
        "purchasePrice": 40,
        "salePrice": 42,
        "duration": 210,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Bauxite",
        "level": 1,
        "purchasePrice": 110,
        "salePrice": 115.5,
        "duration": 330,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Lithium Ore",
        "level": 1,
        "purchasePrice": 130,
        "salePrice": 136.5,
        "duration": 340,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Magnesium",
        "level": 1,
        "purchasePrice": 95,
        "salePrice": 99.75,
        "duration": 310,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Potassium",
        "level": 1,
        "purchasePrice": 85,
        "salePrice": 89.25,
        "duration": 300,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Phosphorus",
        "level": 1,
        "purchasePrice": 70,
        "salePrice": 73.5,
        "duration": 280,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Uranium",
        "level": 1,
        "purchasePrice": 500,
        "salePrice": 525,
        "duration": 400,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Thorium",
        "level": 1,
        "purchasePrice": 600,
        "salePrice": 630,
        "duration": 450,
        "requiredMaterials": [],
        "inflation": 0
      },
      {
        "name": "Wheat",
        "level": 2,
        "purchasePrice": 90,
        "salePrice": 95,
        "duration": 300,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Corn",
        "level": 2,
        "purchasePrice": 85,
        "salePrice": 89,
        "duration": 320,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Cotton",
        "level": 2,
        "purchasePrice": 75,
        "salePrice": 78.75,
        "duration": 280,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Sugarcane",
        "level": 2,
        "purchasePrice": 70,
        "salePrice": 73.5,
        "duration": 260,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Tobacco",
        "level": 2,
        "purchasePrice": 95,
        "salePrice": 99.75,
        "duration": 300,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Rice",
        "level": 2,
        "purchasePrice": 90,
        "salePrice": 95,
        "duration": 340,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Barley",
        "level": 2,
        "purchasePrice": 80,
        "salePrice": 84,
        "duration": 330,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Soybeans",
        "level": 2,
        "purchasePrice": 78,
        "salePrice": 81.9,
        "duration": 320,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Vegetables",
        "level": 2,
        "purchasePrice": 95,
        "salePrice": 99.75,
        "duration": 350,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Fruits",
        "level": 2,
        "purchasePrice": 100,
        "salePrice": 105,
        "duration": 360,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Olives",
        "level": 2,
        "purchasePrice": 110,
        "salePrice": 115.5,
        "duration": 330,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Hops",
        "level": 2,
        "purchasePrice": 88,
        "salePrice": 92.4,
        "duration": 280,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Coffee Beans",
        "level": 2,
        "purchasePrice": 120,
        "salePrice": 126,
        "duration": 390,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Rubber",
        "level": 2,
        "purchasePrice": 130,
        "salePrice": 136.5,
        "duration": 400,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Fish",
        "level": 2,
        "purchasePrice": 140,
        "salePrice": 147,
        "duration": 410,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Timber",
        "level": 2,
        "purchasePrice": 150,
        "salePrice": 157.5,
        "duration": 430,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Wool",
        "level": 2,
        "purchasePrice": 95,
        "salePrice": 99.75,
        "duration": 280,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Milk",
        "level": 2,
        "purchasePrice": 85,
        "salePrice": 89.25,
        "duration": 260,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Leather",
        "level": 2,
        "purchasePrice": 70,
        "salePrice": 73.5,
        "duration": 310,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Honey",
        "level": 2,
        "purchasePrice": 105,
        "salePrice": 110.25,
        "duration": 300,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Eggs",
        "level": 2,
        "purchasePrice": 50,
        "salePrice": 52.5,
        "duration": 240,
        "requiredMaterials": ["Water"],
        "inflation": 0
      },
      {
        "name": "Cheese",
        "level": 2,
        "purchasePrice": 120,
        "salePrice": 126,
        "duration": 320,
        "requiredMaterials": ["Milk"],
        "inflation": 0
      },
      {
        "name": "Butter",
        "level": 2,
        "purchasePrice": 115,
        "salePrice": 120.75,
        "duration": 280,
        "requiredMaterials": ["Milk"],
        "inflation": 0
      },
      {
        "name": "Wheat Flour",
        "level": 3,
        "purchasePrice": 130,
        "salePrice": 136.5,
        "duration": 400,
        "requiredMaterials": ["Wheat"],
        "inflation": 0
      },
      {
        "name": "Bread",
        "level": 3,
        "purchasePrice": 140,
        "salePrice": 147,
        "duration": 420,
        "requiredMaterials": ["Wheat Flour", "Water"],
        "inflation": 0
      },
      {
        "name": "Beef",
        "level": 3,
        "purchasePrice": 150,
        "salePrice": 157.5,
        "duration": 440,
        "requiredMaterials": ["Cattle"],
        "inflation": 0
      },
      {
        "name": "Pork",
        "level": 3,
        "purchasePrice": 145,
        "salePrice": 152.25,
        "duration": 450,
        "requiredMaterials": ["Pig"],
        "inflation": 0
      },
      {
        "name": "Chicken Meat",
        "level": 3,
        "purchasePrice": 135,
        "salePrice": 141.75,
        "duration": 430,
        "requiredMaterials": ["Chicken"],
        "inflation": 0
      },
      {
        "name": "Steel",
        "level": 3,
        "purchasePrice": 160,
        "salePrice": 168,
        "duration": 450,
        "requiredMaterials": ["Iron Ore", "Coal"],
        "inflation": 0
      },
      {
        "name": "Copper Wire",
        "level": 3,
        "purchasePrice": 170,
        "salePrice": 178.5,
        "duration": 460,
        "requiredMaterials": ["Copper Ore"],
        "inflation": 0
      },
      {
        "name": "Glass",
        "level": 3,
        "purchasePrice": 130,
        "salePrice": 136.5,
        "duration": 440,
        "requiredMaterials": ["Sand"],
        "inflation": 0
      },
      {
        "name": "Concrete",
        "level": 3,
        "purchasePrice": 125,
        "salePrice": 131.25,
        "duration": 440,
        "requiredMaterials": ["Sand", "Limestone"],
        "inflation": 0
      },
      {
        "name": "Cloth",
        "level": 3,
        "purchasePrice": 115,
        "salePrice": 120.75,
        "duration": 400,
        "requiredMaterials": ["Cotton"],
        "inflation": 0
      },
      {
        "name": "Paper",
        "level": 3,
        "purchasePrice": 110,
        "salePrice": 115.5,
        "duration": 420,
        "requiredMaterials": ["Timber"],
        "inflation": 0
      },
      {
        "name": "Leather Shoes",
        "level": 3,
        "purchasePrice": 160,
        "salePrice": 168,
        "duration": 430,
        "requiredMaterials": ["Leather"],
        "inflation": 0
      },
      {
        "name": "Wooden Furniture",
        "level": 3,
        "purchasePrice": 180,
        "salePrice": 189,
        "duration": 470,
        "requiredMaterials": ["Timber"],
        "inflation": 0
      },
      {
        "name": "Brick",
        "level": 3,
        "purchasePrice": 140,
        "salePrice": 147,
        "duration": 410,
        "requiredMaterials": ["Clay"],
        "inflation": 0
      },
      {
        "name": "Sugar",
        "level": 3,
        "purchasePrice": 125,
        "salePrice": 131.25,
        "duration": 420,
        "requiredMaterials": ["Sugarcane"],
        "inflation": 0
      },
      {
        "name": "Jam",
        "level": 3,
        "purchasePrice": 145,
        "salePrice": 152.25,
        "duration": 410,
        "requiredMaterials": ["Fruits", "Sugar"],
        "inflation": 0
      },
      {
        "name": "Canned Fish",
        "level": 3,
        "purchasePrice": 155,
        "salePrice": 162.75,
        "duration": 440,
        "requiredMaterials": ["Fish", "Tin"],
        "inflation": 0
      },
      {
        "name": "Juice",
        "level": 3,
        "purchasePrice": 130,
        "salePrice": 136.5,
        "duration": 400,
        "requiredMaterials": ["Fruits", "Water"],
        "inflation": 0
      },
      {
        "name": "Yogurt",
        "level": 3,
        "purchasePrice": 135,
        "salePrice": 141.75,
        "duration": 390,
        "requiredMaterials": ["Milk"],
        "inflation": 0
      },
      {
        "name": "Plastic",
        "level": 3,
        "purchasePrice": 165,
        "salePrice": 173.25,
        "duration": 450,
        "requiredMaterials": ["Oil"],
        "inflation": 0
      },
      {
        "name": "Battery",
        "level": 3,
        "purchasePrice": 190,
        "salePrice": 199.5,
        "duration": 480,
        "requiredMaterials": ["Copper", "Lithium"],
        "inflation": 0
      },
      {
        "name": "Processed Wood",
        "level": 3,
        "purchasePrice": 105,
        "salePrice": 110.25,
        "duration": 390,
        "requiredMaterials": ["Timber"],
        "inflation": 0
      },
      {
        "name": "Pet Food",
        "level": 3,
        "purchasePrice": 120,
        "salePrice": 126,
        "duration": 370,
        "requiredMaterials": ["Meat", "Grains"],
        "inflation": 0
      },
      {
        "name": "Petrol",
        "level": 3,
        "purchasePrice": 155,
        "salePrice": 162.75,
        "duration": 460,
        "requiredMaterials": ["Oil"],
        "inflation": 0
      },
      {
        "name": "Engine",
        "level": 4,
        "purchasePrice": 220,
        "salePrice": 231,
        "duration": 520,
        "requiredMaterials": ["Steel", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Laptop",
        "level": 4,
        "purchasePrice": 300,
        "salePrice": 315,
        "duration": 680,
        "requiredMaterials": ["Plastic", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Smartphone",
        "level": 4,
        "purchasePrice": 290,
        "salePrice": 304.5,
        "duration": 650,
        "requiredMaterials": ["Plastic", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Car",
        "level": 4,
        "purchasePrice": 400,
        "salePrice": 420,
        "duration": 700,
        "requiredMaterials": ["Engine", "Steel", "Plastic"],
        "inflation": 0
      },
      {
        "name": "TV",
        "level": 4,
        "purchasePrice": 280,
        "salePrice": 294,
        "duration": 660,
        "requiredMaterials": ["Plastic", "Glass", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Refrigerator",
        "level": 4,
        "purchasePrice": 320,
        "salePrice": 336,
        "duration": 700,
        "requiredMaterials": ["Plastic", "Steel", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Washing Machine",
        "level": 4,
        "purchasePrice": 330,
        "salePrice": 346.5,
        "duration": 710,
        "requiredMaterials": ["Plastic", "Steel", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Drone",
        "level": 4,
        "purchasePrice": 350,
        "salePrice": 367.5,
        "duration": 720,
        "requiredMaterials": ["Plastic", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Medical Equipment",
        "level": 4,
        "purchasePrice": 390,
        "salePrice": 409.5,
        "duration": 760,
        "requiredMaterials": ["Plastic", "Steel", "Battery"],
        "inflation": 0
      },
      {
        "name": "Tablet",
        "level": 4,
        "purchasePrice": 295,
        "salePrice": 309.75,
        "duration": 640,
        "requiredMaterials": ["Plastic", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Air Conditioner",
        "level": 4,
        "purchasePrice": 340,
        "salePrice": 357,
        "duration": 730,
        "requiredMaterials": ["Plastic", "Steel", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Electric Scooter",
        "level": 4,
        "purchasePrice": 310,
        "salePrice": 325.5,
        "duration": 690,
        "requiredMaterials": ["Plastic", "Battery", "Steel"],
        "inflation": 0
      },
      {
        "name": "Electric Bike",
        "level": 4,
        "purchasePrice": 370,
        "salePrice": 388.5,
        "duration": 720,
        "requiredMaterials": ["Plastic", "Battery", "Steel"],
        "inflation": 0
      },
      {
        "name": "Robot",
        "level": 4,
        "purchasePrice": 500,
        "salePrice": 525,
        "duration": 800,
        "requiredMaterials": ["Battery", "Copper Wire", "Plastic"],
        "inflation": 0
      },
      {
        "name": "Microwave",
        "level": 4,
        "purchasePrice": 310,
        "salePrice": 325.5,
        "duration": 700,
        "requiredMaterials": ["Plastic", "Steel", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Gaming Console",
        "level": 4,
        "purchasePrice": 330,
        "salePrice": 346.5,
        "duration": 710,
        "requiredMaterials": ["Plastic", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Vacuum Cleaner",
        "level": 4,
        "purchasePrice": 260,
        "salePrice": 273,
        "duration": 630,
        "requiredMaterials": ["Plastic", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Electric Oven",
        "level": 4,
        "purchasePrice": 325,
        "salePrice": 341.25,
        "duration": 710,
        "requiredMaterials": ["Plastic", "Steel", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Industrial Robot Arm",
        "level": 4,
        "purchasePrice": 550,
        "salePrice": 577.5,
        "duration": 820,
        "requiredMaterials": ["Steel", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "3D Printer",
        "level": 4,
        "purchasePrice": 380,
        "salePrice": 399,
        "duration": 750,
        "requiredMaterials": ["Plastic", "Steel", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Smart Home Hub",
        "level": 4,
        "purchasePrice": 260,
        "salePrice": 273,
        "duration": 610,
        "requiredMaterials": ["Plastic", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Solar Panel",
        "level": 4,
        "purchasePrice": 450,
        "salePrice": 472.5,
        "duration": 780,
        "requiredMaterials": ["Plastic", "Glass", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Wind Turbine",
        "level": 4,
        "purchasePrice": 620,
        "salePrice": 651,
        "duration": 850,
        "requiredMaterials": ["Steel", "Copper Wire", "Plastic"],
        "inflation": 0
      },
      {
        "name": "Electric Car",
        "level": 4,
        "purchasePrice": 750,
        "salePrice": 787.5,
        "duration": 900,
        "requiredMaterials": ["Battery", "Steel", "Copper Wire", "Plastic"],
        "inflation": 0
      },
      {
        "name": "Space Satellite",
        "level": 5,
        "purchasePrice": 1200,
        "salePrice": 1260,
        "duration": 1200,
        "requiredMaterials": ["Steel", "Battery", "Solar Panel", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Space Habitat Module",
        "level": 5,
        "purchasePrice": 1800,
        "salePrice": 1890,
        "duration": 1400,
        "requiredMaterials": ["Steel", "Plastic", "Battery", "Glass"],
        "inflation": 0
      },
      {
        "name": "Space Rover",
        "level": 5,
        "purchasePrice": 1500,
        "salePrice": 1575,
        "duration": 1300,
        "requiredMaterials": ["Steel", "Battery", "Solar Panel", "Glass"],
        "inflation": 0
      },
      {
        "name": "Mars Oxygen Generator",
        "level": 5,
        "purchasePrice": 1600,
        "salePrice": 1680,
        "duration": 1350,
        "requiredMaterials": ["Steel", "Battery", "Plastic", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Space Suit",
        "level": 5,
        "purchasePrice": 1100,
        "salePrice": 1155,
        "duration": 1250,
        "requiredMaterials": ["Plastic", "Glass", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Rocket Engine",
        "level": 5,
        "purchasePrice": 2500,
        "salePrice": 2625,
        "duration": 1500,
        "requiredMaterials": ["Steel", "Battery", "Copper Wire", "Fuel"],
        "inflation": 0
      },
      {
        "name": "Space Telescope",
        "level": 5,
        "purchasePrice": 2000,
        "salePrice": 2100,
        "duration": 1400,
        "requiredMaterials": ["Glass", "Steel", "Battery", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Solar Sail",
        "level": 5,
        "purchasePrice": 1300,
        "salePrice": 1365,
        "duration": 1200,
        "requiredMaterials": ["Plastic", "Solar Panel", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Cryogenic Fuel Tank",
        "level": 5,
        "purchasePrice": 2200,
        "salePrice": 2310,
        "duration": 1450,
        "requiredMaterials": ["Steel", "Plastic", "Copper Wire", "Fuel"],
        "inflation": 0
      },
      {
        "name": "Space Dock",
        "level": 5,
        "purchasePrice": 2800,
        "salePrice": 2940,
        "duration": 1550,
        "requiredMaterials": ["Steel", "Battery", "Solar Panel", "Glass"],
        "inflation": 0
      },
      {
        "name": "Planetary Drill",
        "level": 5,
        "purchasePrice": 2100,
        "salePrice": 2205,
        "duration": 1350,
        "requiredMaterials": ["Steel", "Battery", "Copper Wire", "Drill Bit"],
        "inflation": 0
      },
      {
        "name": "Radiation Shield",
        "level": 5,
        "purchasePrice": 1700,
        "salePrice": 1785,
        "duration": 1300,
        "requiredMaterials": ["Plastic", "Steel", "Glass", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Ion Thruster",
        "level": 5,
        "purchasePrice": 2300,
        "salePrice": 2415,
        "duration": 1450,
        "requiredMaterials": ["Steel", "Battery", "Copper Wire", "Xenon Fuel"],
        "inflation": 0
      },
      {
        "name": "Artificial Gravity Generator",
        "level": 5,
        "purchasePrice": 3000,
        "salePrice": 3150,
        "duration": 1600,
        "requiredMaterials": ["Steel", "Battery", "Copper Wire", "Magnet"],
        "inflation": 0
      },
      {
        "name": "Extraterrestrial Farm Module",
        "level": 5,
        "purchasePrice": 1900,
        "salePrice": 1995,
        "duration": 1350,
        "requiredMaterials": ["Plastic", "Steel", "Battery", "Water"],
        "inflation": 0
      },
      {
        "name": "Asteroid Mining Drill",
        "level": 5,
        "purchasePrice": 2500,
        "salePrice": 2625,
        "duration": 1500,
        "requiredMaterials": ["Steel", "Battery", "Drill Bit", "Copper Wire"],
        "inflation": 0
      },
      {
        "name": "Space Beacon",
        "level": 5,
        "purchasePrice": 1600,
        "salePrice": 1680,
        "duration": 1200,
        "requiredMaterials": ["Steel", "Battery", "Copper Wire", "Plastic"],
        "inflation": 0
      },
      {
        "name": "Mars Transportation Pod",
        "level": 5,
        "purchasePrice": 2700,
        "salePrice": 2835,
        "duration": 1550,
        "requiredMaterials": ["Steel", "Battery", "Plastic", "Glass"],
        "inflation": 0
      },
      {
        "name": "Interstellar Communication Array",
        "level": 5,
        "purchasePrice": 2400,
        "salePrice": 2520,
        "duration": 1500,
        "requiredMaterials": ["Steel", "Battery", "Copper Wire", "Glass"],
        "inflation": 0
      },
      {
        "name": "Fusion Reactor Core",
        "level": 5,
        "purchasePrice": 5000,
        "salePrice": 5250,
        "duration": 1800,
        "requiredMaterials": ["Steel", "Battery", "Magnet", "Cooling System"],
        "inflation": 0
      }
    ];
  List<Map<String, dynamic>> get allproducts => products;

  Future<void> addProductsToFirestore() async {
    //DEV. RESET--------------------------
    // Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Ürünlerin JSON formatında listesi
    
    // Firestore batch işlemi
    // Firestore batch işlemi
    WriteBatch batch = firestore.batch();

    // Her bir ürünü "products" koleksiyonuna ekliyoruz
    for (Map<String, dynamic> product in products) {
      batch.set(firestore.collection('products').doc(), product);
    }
    try {
      await batch.commit();
      print('Ürünler başarıyla Firestore\'a eklendi.');
    } catch (e) {
      print('Ürünler eklenirken hata oluştu: $e');
    }
  }

  /// Deletes repeated products from the Firestore 'products' collection.
  /// This function iterates over all documents in the collection and
  /// removes any duplicates based on the 'name' field.
  Future<void> deleteRepeatedProducts() async {
    //DEV. RESET--------------------------
    try {
      final Set<String> uniqueNames = {}; // set to store unique product names
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('products').get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        if (doc.exists && doc.data().containsKey('name')) {
          final String name = doc['name'] as String;
          if (!uniqueNames.add(name)) {
            // if the product name is already in the set, it means it's a duplicate
            await FirebaseFirestore.instance
                .collection('products')
                .doc(doc.id)
                .delete();
          }
        }
      }
    } on FirebaseException catch (e) {
      print('Ürünler silinirken hata oluştu: $e');
    } catch (e) {
      print('Ürünler silinirken bilinmeyen hata oluştu: $e');
    }
  }

  Future<void> firebaseChangeWordsInCollections(String collectionPath,
      String oldWord, String newWord, dynamic value) async {
    //DEV. RESET--------------------------
    final batch = FirebaseFirestore.instance.batch();
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    final snapshots = await collectionRef.get();

    for (final doc in snapshots.docs) {
      if (doc.exists && doc.data().containsKey(oldWord)) {
        batch.update(doc.reference, {
          oldWord: FieldValue.delete(),
          newWord: value,
        });
      }
    }

    try {
      await batch.commit();
    } on FirebaseException catch (e) {
      print('Ürünler güncellenirken hata oluştu: $e');
    } on Exception catch (e) {
      print('Ürünler güncellenirken bilinmeyen hata oluştu: $e');
    }
  }

  Future<void> signUpToFirebaseUsers(
      String id,
      String nickname,
      String email,
      Map<Factory, int> factories,
      Map< String , Map< Product, int > > products,
      Map<City, int> cities) async {
    if ([id, nickname, email].any((element) => element.isEmpty)) {
      print('Invalid input: all fields must be non-empty.');
      return;
    }
    try {
      final userData = {
        'id': id,
        'nickname': nickname,
        'email': email,
        'money': 1000,
        'factories': factories,
        'products': products,
        'cities': cities
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .set(userData);
      print('User successfully created.');
    } on FirebaseException catch (e) {
      print(e.code == 'permission-denied'
          ? 'Permission denied: $e'
          : 'Error creating user: $e');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  Future<int> findUserMoney() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
      if (documentSnapshot.exists) {
        print('User money: ${documentSnapshot.data()!['money']}');
        return int.parse(documentSnapshot.data()!['money'].toString());
      } else {
        return 0;
      }
    } on FirebaseException catch (e) {
      print('Error fetching user money: $e');
      return 0;
    } on Exception catch (e) {
      print('An unexpected error occurred while fetching user money: $e');
      return 0;
    }
  }

  Future<void> updateRequredMaterialsAsMap() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        if (doc.data().containsKey('requiredMaterials')) {
          List<Map<String, dynamic>> requiredMaterials = [];
          for (Map<String, dynamic> requiredMaterial
              in doc.data()['requiredMaterials']) {
            requiredMaterials.add(requiredMaterial);
          }
          doc.reference.update({
            'requiredMaterials': requiredMaterials.map((e) => {e: "2"}).toList()
          });
        }
      }
    });
  }

  Future<bool> canBeProducedByCheckingRequiredMaterials(String name) async {
    try {
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (productDoc.docs.isEmpty) return false;

      final requiredMaterials = productDoc.docs.first
          .data()['requiredMaterials']
          ?.cast<Map<String, dynamic>>();

      if (requiredMaterials == null) return false;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (!userDoc.exists) return false;

      final userProducts = userDoc.data()?['products'];

      if (userProducts == null) return false;

      for (final material in requiredMaterials) {
        final materialName = material['name'];
        final requiredQty = material['quantity'];

        if (userProducts[materialName] == null ||
            userProducts[materialName] < requiredQty) {
          return false;
        }
      }
      return true;
    } on FirebaseException catch (e) {
      print('Error checking if product can be produced: $e');
      return false;
    } on Exception catch (e) {
      print('An unexpected error occurred: $e');
      return false;
    }
  }
}
