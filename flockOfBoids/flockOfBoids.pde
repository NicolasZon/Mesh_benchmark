/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 * 
 * This example displays the 2D famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 and then adapted to Processing in 3D by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * Boids under the mouse will be colored blue. If you click on a boid it will be
 * selected as the scene avatar for the eye to follow it.
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the mesh visual mode.
 * Press 't' to shift timers: sequential and parallel.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 */

import frames.input.*;
import frames.input.event.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Scene scene;
int flockWidth = 1280;
int flockHeight = 720;
int flockDepth = 600;
boolean avoidWalls = true;

// visual modes
// 0. Faces and edges
// 1. Wireframe (only edges)
// 2. Only faces
// 3. Only points
int mode;

int initBoidNum = 900; // amount of boids to start the program with
ArrayList<Boid> flock;
Node avatar;
boolean animate = true;


  int fcount, lastm, alto, ancho, dx, dy;
  float frate, fanterior;
  int fint = 3;
  PFont font;
  PShape s;
  boolean estados =false;          // true: Vertex-vertex,  false: Face-vertex
  boolean modificainre = false;    // true: Retenido,  false: Inmediato
  Face_vertex fv;
  Vertex_vertex vv;
  
  
  float fps[] = new float[500];
  

void setup() {
  size(1000, 800, P3D);
  frameRate(60);
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  Eye eye = new Eye(scene);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  //interactivity defaults to the eye
  scene.setDefaultGrabber(eye);
  scene.fitBall();
  fanterior = frameRate;
  
  println(frameRate);
  fps[frameCount] = 0; 
  dx = 250;
  dy = 30;
  alto = 100;
  ancho = 500;
  
  // create and fill the list of boids
  flock = new ArrayList();
  fv = new Face_vertex();
  s = fv.getShape();
  vv= new Vertex_vertex();
  for (int i = 0; i < initBoidNum; i++)
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
  font = createFont("Arial Bold",48);
}

void draw() {
  background(0);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  // Calls Node.visit() on all scene nodes.
  scene.traverse();
  ////////////////////////////////////////////////////
    scene.beginScreenCoordinates();
    
    fps[frameCount%500] = frameRate;  //  Arreglo para frames se usa porque el background pinta en negro
    pushStyle();
    strokeWeight(3);
    stroke(255);
    line(dx,dy,dx,dy+alto); //linea vertical
    line(dx,dy+alto,dx+ancho,dy+alto); //linea horizontal
    popStyle();
    pushStyle();
    strokeWeight(3);
    stroke(color(255,92,92)); //color rojo
    textFont(font,15); //fuentes de Tiempo
    text("Tiempo",dx+ancho-20,dy+alto+20); //coordenada y texto del tiempo
    textFont(font,15); //texto de la fuente del FPS
    text("FPS",dx-40,dy+20);
    text(" " + java.lang.Math.round(frameRate*100.0)/100.0, dx-50,(dy+alto)/2); //texto de los frames con el truncamiento a dos decimas
    for(int i = 1; i<frameCount && i<500; i++){
        line((i+(dx-1))%(ancho+dx), ((dy+alto)-((fps[i-1]/60)*100)), (i+dx)%(dx+ancho), ((dy+alto)-(fps[i]/60)*100)); //realiza la linea del benchmarck 
    }
    stroke(255);
    strokeWeight(2);
    line(dx+frameCount%500, dy+alto+5, dx+frameCount%500, dy+alto-5);
    line(dx, dy, dx+5, dy+5); //linea del triangulo superior
    line(dx, dy, dx-5, dy+5); //linea del triangulo superior
    line(dx+ancho, dy+alto, dx+ancho-5, dy+alto-5); //linea del triangulo derecho 
    line(dx+ancho, dy+alto, dx+ancho-5, dy+alto+5); //linea del triangulo derecho
    
    popStyle();
    scene.endScreenCoordinates(); //salir de la escena para pintar la grafica
    fill(0);   
   /////////////////////////
    textFont(font,40);
   // white float frameRate
  //////////////////////////////////
    fill(255);
    if(modificainre){ //modificacion a modo retenido e inmediato
    text("Retenido", 12, 60);
    
    }else{
    text("Inmediato", 12, 60);
    }
    text("fps: " + java.lang.Math.round(frameRate*100.0)/100.0, 12, 100);
    if(estados){ //modificacion a modo vertex_vertex y FaceVertex_vertex 
    text("Vertex_vertex", 500, 60);
    }else{
    text("Face_Vertex", 500, 60);
    }
  
}

void walls() {
  pushStyle();
  noFill();
  stroke(255);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void keyPressed() {
  switch (key) {
  case 'z':      // Cambio entre face-vertex y vertex-vertex
     if(estados == true){
       s=fv.getShape();
       estados= false;
     }else{
       s = vv.getShape();
       estados= true;
     }
     break;
  case 'r':   //cambio entre retenido e inmediato 
    //modificainre ^= true;
     if(modificainre == true){
       modificainre= false;
     }else{
       modificainre= true;
     }
    
    break;
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fitBallInterpolation();
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  case 'm':
    mode = mode < 3 ? mode+1 : 0;
    break;
  case ' ':
    if (scene.eye().reference() != null) {
      scene.lookAt(scene.center());
      scene.fitBallInterpolation();
      scene.eye().setReference(null);
    } else if (avatar != null) {
      scene.eye().setReference(avatar);
      scene.interpolateTo(avatar);
    }
    break;
  }
}