float offsetX = 0;

import processing.sound.*;
Oscillator oscs[] = new Oscillator[3];

float fundamental = 300;

int snapGridDepth = 11;
ArrayList<PVector> snapGrid = new ArrayList<PVector>();
PVector[][] nearestSnapGrid;

float attack = 0.01f;
float decay = 0.30f;
float sustain = 0.5f;
float release = 1.0f;

float amp = 0;
float timeSincePhaseChange = 0;
int currentPhase = 0;

void setup()
{
  size(840, 840);
  noStroke();
  background(0);
  

  // render backdrop
  render(color(255, 60), 80, 1, false);
  render(color(255, 0, 0, 255), snapGridDepth, 40, true);

  // init sound
  oscs[0] = new SinOsc(this);
  oscs[1] = new SinOsc(this);
  oscs[2] = new SinOsc(this);

  generateSnapGrid();
  
  for (int i = 0; i < oscs.length; i++)
    oscs[i].play();
    
    print(snapGrid);
}

void render(color col, int depth, float size, boolean proportionalSize)
{
  fill(col);
  drawPointGrid(depth, size, proportionalSize);
}

void generateSnapGrid()
{
  for (int z = snapGridDepth; z > 0; z--)
    for (int y = -z - 1; y <= z + 1; y++)
      for (int x = -z - 1; x <= z + 1; x++)
      {
        PVector screenPos = worldToScreenPos(float(x ), float(y), z);
        snapGrid.add(screenPos);
      }
      
        nearestSnapGrid = new PVector[width][height];

  for(int x = 0; x < width; x++)
  {
   for(int y = 0; y < height; y++)
  {
  nearestSnapGrid[x][y] = GetNearestSnapPos(x,y);
  }
  }
}

PVector GetNearestSnapPos(int x, int y)
{
  PVector pos = new PVector(x, y);

  if (snapGrid.size() == 0)
    return pos;

  PVector nearestSnapPos = snapGrid.get(0);
  float nearestDist = PVector.dist(nearestSnapPos, pos);

  for (int i = 0; i < snapGrid.size(); i++)
  {
    float dist = PVector.dist(snapGrid.get(i), pos);
    if(dist <= nearestDist)
    {
      nearestDist = dist;
      nearestSnapPos = snapGrid.get(i);
    }
  }

  return nearestSnapPos;
}
boolean wasPressedLast = false;

void draw()
{
  if(mousePressed && !wasPressedLast)
  {
      currentPhase = 0;
      timeSincePhaseChange = 0;
      PVector snappedPos = nearestSnapGrid[mouseX][mouseY];
      //snappedPos = new PVector(mouseX, mouseY);
      fill(0,255,0,255);
      
      PVector direction = new PVector((snappedPos.x - (height/2)) / 360, (snappedPos.y - (width/2)) / 360,1);
      direction = direction.mult(fundamental);
    
      oscs[0].freq(direction.x);
      oscs[1].freq(direction.y);
      oscs[2].freq(direction.z);
      wasPressedLast = true;
  }
  
  if (!mousePressed && currentPhase == 2)
  {
      currentPhase = 3;
      timeSincePhaseChange = 0;
      wasPressedLast = false;
  }
      
       for (int i = 0; i < oscs.length; i++)
    oscs[i].amp(amp);

 
  
  timeSincePhaseChange += 0.01f;
  
  switch(currentPhase)
  {
  case 0:
    if(timeSincePhaseChange > attack)
    {
    timeSincePhaseChange = 0;
    currentPhase = 1;
    }
    
  break;
  case 1:
    if(timeSincePhaseChange > decay)
    {
    timeSincePhaseChange = 0;
    currentPhase = 2;
    }
    
  break;
  }
  
  amp = ampEnv(attack, sustain, decay, release, timeSincePhaseChange, currentPhase);
}

float ampEnv(float a, float d, float s, float r, float t, int phase)
{
  float value = 0;
  switch(phase)
  {
  case 0:
    value =  t / a;
  break;
  case 1:
    value = lerp(1,s, t/d);
  break;
  case 2:
    value = s;
  break;
  case 3:
    value = max(0,lerp(s,0,t/r));
  }
  
  return value;
}

void drawPointGrid(int depth, float size, boolean proportionalSize)
{
  for (int z = depth; z > 0; z--)
    for (int y = -z - 1; y <= z + 1; y++)
      for (int x = -z - 1; x <= z + 1; x++)
      {
        float scaledSize = size;
        if(proportionalSize)
        {
          scaledSize /= z;
        }
        
        renderAtPoint(x, y, z, scaledSize);
      }
}

void drawLineGrid(int depth, float thickness)
{
  strokeWeight(thickness);
  stroke(255,150);
  
  for (int z = depth; z > 0; z--)
    for (int y = -z - 1; y <= z + 1; y++)
      {
      PVector referencePos = worldToScreenPos(0,y,z);
      line(0,referencePos.y, width, referencePos.y);
      }
      
    for (int z = depth; z > 0; z--)
    for (int x = -z - 1; x <= z + 1; x++)
      {
      PVector referencePos = worldToScreenPos(x,0, z);
      line(referencePos.x,0, referencePos.x,height);
      }
      
   for (int z = depth; z > 0; z--)
   for (int y = -z - 1; y <= z + 1; y++)
    for (int x = -z - 1; x <= z + 1; x++)
      {
      PVector referencePos = worldToScreenPos(x,y,z);
      line(width/2, height/2, referencePos.x, referencePos.y);
      }
}

PVector worldToScreenPos(float x, float y, float z)
{
  float clipX, clipY, screenX, screenY;

  clipX = (float)(offsetX + x) / z;
  clipY = (float)y / z;

  screenX = (clipX + 1) * 720 / 2 + 60;
  screenY = (clipY + 1) * 720 / 2+ 60;

  return new PVector(screenX, screenY);
}

void renderAtPoint(int x, int y, int z, float radius)
{
  PVector screenPos = worldToScreenPos(x, y, z);

  circle(screenPos.x, screenPos.y, radius);
}
