int width = 800, height = 600;
float velocity;
float posibility = 0.5;
int points = 0, failed = 0, backgroundColor = 255;
Shape shape;

void setup()
{
  size(800, 600);
  CreateNewShape();
}

void CreateNewShape()
{
  ShapeFormat shapeFormat = GetShapeFormat();
  switch (shapeFormat)
  {
    case Circle:
      shape = CreateCircle();
    break;
    case Rectangle:
      shape = CreateRectangle();
    break;
  }
}

ShapeFormat GetShapeFormat()
{
  float choose = random(1);
  if (choose < posibility)
  {
    return ShapeFormat.Circle;
  }
  else
  {
    return ShapeFormat.Rectangle;
  }
}

Shape CreateCircle()
{
  SetStartVelocity();
  return new Circle(); 
}

Shape CreateRectangle()
{
  SetStartVelocity();
  return new Rectangle();
}

void SetStartVelocity()
{
  velocity = random(-19, -10);
}

void draw()
{  
  background(backgroundColor);
  shape.Draw();
  velocity = shape.MoveOnY(velocity, backgroundColor);
  
  if (shape.HadNoHit())
  {
    CreateNewShape();
    failed++;
  }
  
  fill(0);
  text("Points: " + points + ", Failed: " + failed, 10, 10);
}

void mousePressed()
{
  if (shape.IsHit())
  {
    points++;
    CreateNewShape();
  }
}

abstract class Shape
{
  int Red, Green, Blue;
  int X, Y;
  
  Shape()
  {
    Red = round(random(255));
    Green = round(random(255));
    Blue = round(random(255));
  }
  
  float MoveOnY(float velocity, int backgroundColor)
  {
    Clear(backgroundColor);
    Y += velocity;
    Draw();
    DrawShape();
    return velocity += 0.3;
  }
  
  void Draw()
  {
    stroke(0);
    fill(Red, Green, Blue);
  }
  
  void Clear(int background)
  {
    fill(background);
    stroke(backgroundColor);
    DrawShape();
  }
  
  abstract boolean IsHit();
  
  abstract boolean HadNoHit();
  
  abstract void DrawShape();
}

class Circle extends Shape
{
  int Radius;
  int minRadius = 30, maxRadius = 70;

  Circle()
  {
    Radius = round(random(minRadius, maxRadius));
    X = round(random(Radius, width - Radius));
    Y = height + Radius;
  }
  
  void Draw()
  {
    super.Draw();
    DrawShape();
  }

  void DrawShape()
  {
    ellipse(X, Y, Radius, Radius);
  }
  
  boolean IsHit()
  {
    int distance = round(dist(mouseX , mouseY, X, Y));
    return distance <= Radius;
  }
  
  boolean HadNoHit()
  {
    return Y > height + Radius;
  }
}

class Rectangle extends Shape
{
  int Width;
  int Height;

  int minWidth = 30, maxWidth = 70;
  int minHeight = 30, maxHeight = 70;
  
  Rectangle()
  {
    Width = round(random(minWidth, maxWidth));
    Height = round(random(minHeight, maxHeight));
    X = round(random(Width, width - Width));
    Y = height + Height;
  }
  
  void Draw()
  {
    super.Draw();
    DrawShape();
  }
  
  void DrawShape()
  {
    rect(X, Y, Width, Height);
  }

  boolean IsHit()
  {
    int mX = mouseX;
    int mY = mouseY;    
    return (mX >= X) && (mX <= X + Width) && (mY >= Y) && (mY <= Y + Height);
  }
  
  boolean HadNoHit()
  {
    return Y > height + Height;
  }
}

enum ShapeFormat
{
  Circle,
  Rectangle
}