

class Vertex_vertex{
  
  ArrayList<PVector> coordenadas= new ArrayList<PVector>();
  ArrayList<Integer[]> vert_adj = new ArrayList<Integer[]>();
  PShape s;  
  float sc;

  Vertex_vertex(){
     strokeWeight(2);
     stroke(color(0, 255, 0));
     fill(color(255, 0, 0, 125));
    //coordenadas
    coordenadas.add(new PVector(3,0,0));
    coordenadas.add(new PVector(-3,2,0));
    coordenadas.add(new PVector(-3,-2,0));
    coordenadas.add(new PVector(-3,0,2));
    //vertices adjacentes
    vert_adj.add(new Integer[]{1,2,3});
    vert_adj.add(new Integer[]{0,2,3});
    vert_adj.add(new Integer[]{0,1,3});
    vert_adj.add(new Integer[]{0,1,2});
    
    sc = 3;
    creandotetahedro();
}


   void creandotetahedro(){
    s = createShape();
    s.beginShape(TRIANGLES);
    
    for (int i=0; i< vert_adj.size();i++){    //Itera sobre los vertices
      System.out.println("-----i: "+i);
        for(int j=0; j<= vert_adj.get(i).length; j++){    //Itera sobre los vertices adyacentes
          System.out.println("j: "+j);
          System.out.println("j3: "+j%3);
          PVector cor = coordenadas.get(vert_adj.get(i)[j%3]);    //Obtener la coordenada del vertice adyacente actual
          s.vertex(cor.x*sc,cor.y*sc,cor.z*sc);    
        }
    }
    
    s.endShape();

  }
  
  void tetahedroInmediato(){
    beginShape(TRIANGLES);
    
    for (int i=0; i< vert_adj.size();i++){    //Itera sobre los vertices
        for(int j=0; j<= vert_adj.get(i).length; j++){    //Itera sobre los vertices adyacentes
          PVector cor = coordenadas.get(vert_adj.get(i)[j%3]);    //Obtener la coordenada del vertice adyacente actual
          vertex(cor.x*sc,cor.y*sc,cor.z*sc);    
        }
    }
    
    endShape();

  
  
  }
  
  PShape getShape(){
    return s;
  }   
}