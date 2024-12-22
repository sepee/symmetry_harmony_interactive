
String[] dayNames = {"Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun", "NEWDAY"};
PVector[] engagements = {new PVector(0, 09.00, 17.00),
new PVector(1, 14.00, 17.00),
new PVector(1, 19.00, 23.00), // rpg
new PVector(2, 09.00, 11.00),
new PVector(2, 12.00, 16.00), // social
new PVector(3, 09.00, 14.00),
new PVector(4, 16.00, 17.00), 
new PVector(4, 17.00, 24.00), // maths ball
new PVector(5, 00.00, 02.00), // maths ball
};

void setup()
{
  size(1900, 720);
    drawWeek(7, 3, 100, 70, 23, 7);
  drawWeek(8, 3, 200, 530, 21, 7);
  drawWeek(8, 3, 300, -1000, 24,0);

  drawEngagements();
}

void drawWeek(int dayCount, int hourDivisions, int blockY, int textY, int sleepStart, int sleepEnd)
{
  int hoursTotal = 7 * 24;
  int hourCount = hoursTotal / dayCount;
  float dayWidth = width / float(dayCount);
  float hourWidth = width / float(hoursTotal);

  for (int d = 0; d < dayCount; d++)
  {
    stroke(0);

            fill(255);

    rect(dayWidth * d, blockY, dayWidth, 100);
    text(dayNames[d], (d + 0.5f) * dayWidth, textY);


    for (int h = 0; h < hourCount; h++)
    {
      noStroke();
      boolean isSleeping = h >= sleepStart || h < sleepEnd;

      fill(200,200,230);
      if (isSleeping)
      {
        rect(dayWidth * d + hourWidth * h + 1, blockY + 1, hourWidth - 2, 98);
      }

      strokeWeight(1);

      if (h % hourDivisions == 0)
        stroke(150);
      else
        stroke(200);

      if (h == 0)
      {
        stroke(0);
        strokeWeight(2);
              line(dayWidth * d + hourWidth * h, blockY -10, dayWidth * d + hourWidth * h, blockY + 100 - 1);

      }

      line(dayWidth * d + hourWidth * h, blockY + 1, dayWidth * d + hourWidth * h, blockY + 100 - 1);
      strokeWeight(1);
    }
  }
}

void drawEngagements()
{ 
  int hoursTotal = 7 * 24;
  float dayWidth = width / float(7);
  float hourWidth = width / (float)hoursTotal;
  
for(int i = 0; i < engagements.length; i++)
{
int d = (int)engagements[i].x;
int start = (int)engagements[i].y;
int end = (int)engagements[i].z;

float duration = end - start;

noStroke();
fill(240,160,5);

for(int h = start; h < end; h++)
rect(dayWidth * d + hourWidth * h + 2, 150, hourWidth - 4, 100);

}

}
