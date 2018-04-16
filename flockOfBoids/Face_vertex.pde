class Face_vertex{
  ArrayList<Integer[]> face_list = new ArrayList<Integer[]>();
  
  ArrayList<PVector> vertex_list= new ArrayList<PVector>();
  ArrayList<Integer[]> face_adj = new ArrayList<Integer[]>();
  
  float sc=3;
  PShape s;
 
 Face_vertex(){
   strokeWeight(2);
   stroke(color(0, 255, 0));
   fill(color(255, 0, 0, 125));
   //face_list
   face_list.add(new Integer[]{1,2,3});
   face_list.add(new Integer[]{0,1,2});
   face_list.add(new Integer[]{0,1,3});
   face_list.add(new Integer[]{0,2,3});
   //vertices-caras_adj
 
   vertex_list.add(new PVector(3,0,0));
   vertex_list.add(new PVector(-3,2,0));
   vertex_list.add(new PVector(-3,-2,0));
   vertex_list.add(new PVector(-3,0,2));
   face_adj.add(new Integer[]{1,2,3});
   face_adj.add(new Integer[]{0,1,2});
   face_adj.add(new Integer[]{0,1,3});
   face_adj.add(new Integer[]{0,2,3});
   
   creandocaravertice();
 
 
 }
 //modo retenido
 void creandocaravertice(){
   s = createShape();
    s.beginShape(TRIANGLES);
   for(int i=0; i<face_list.size(); i++){
     for(int j=0; j<=face_list.get(i).length; j++){
     PVector vertex = vertex_list.get(face_list.get(i)[j%3]);    //Obtener la coordenada del vertice adyacente actual
          s.vertex(vertex.x*sc,vertex.y*sc,vertex.z*sc);        
     }
   }  
   s.endShape();
 }

//modo inmediato
void creandocaraverticeInmediato(){
    beginShape(TRIANGLES);
    for(int i=0; i<face_list.size(); i++){
     for(int j=0; j<=face_list.get(i).length; j++){
     PVector vertex = vertex_list.get(face_list.get(i)[j%3]);    //Obtener la coordenada del vertice adyacente actual
          vertex(vertex.x*sc,vertex.y*sc,vertex.z*sc);        
     }
   }
   endShape();

}


PShape getShape(){
    return s;
  }

}