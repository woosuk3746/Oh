public class Minion extends Unit {

  private int _health, _attackSpeed;
  private float _dx, _dy;

  public Minion( int health, float x, float y ) {
    super( x, y, 15 );
    _shape = createShape(ELLIPSE, 0, 0, 2*_r, 2*_r);
    _shape.setFill( color( 200, 0, 0 ) );
    _health = health;
    _attackSpeed = 360;
    super.setTime( _attackSpeed / 2 );
    float angle = (float)Math.random() * PI * 2;
    _dx = cos( angle );
    _dy = sin( angle );
  }

  public boolean attackReady() {
    return super.getTime() == 0;
  }

  public void attackReset() {
    super.setTime( _attackSpeed );
  }

  public void hit( TBullet b ) {
    _health -= b.getDamage();
  }

  public boolean isAlive() {
    return _health > 0;
  }

  public void move() {
    _x += _dx;
    _y += _dy;
    if ( outOfBounds() )
      _dx = -_dx;
    if ( outOfBounds() )
      _dy = -_dy;
  }

  public MBullet shoot( float x, float y ) {
    x += 1800 * (x - getX());
    y += 1800 * (y - getY());
    attackReset();
    return new MBullet( x, y, getX(), getY() );
  }
}
