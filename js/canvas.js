// Keep everything in anonymous function, called on window load.
if(window.addEventListener) {
window.addEventListener('load', function () {
  var canvas, context;

  var linkX=235;
  var linkY=475;
  var linkHeight=10;
  var linkWidth;
  var inLink = false;
  var linkText="my@email.address";

  // Initialization sequence.
  function initTextView() {
    // Find the canvas element.
    canvas = document.getElementById('textView');
    if (!canvas) {
      alert('Error: I cannot find the canvas element!');
      return;
    }

    if (!canvas.getContext) {
      alert('Error: no canvas.getContext!');
      return;
    }

    // Get the 2D canvas context.
    context = canvas.getContext('2d');
    if (!context) {
      alert('Error: failed to getContext!');
      return;
    }

    // Fill with background (then it will be an image)
    // context.fillStyle = 'rgba(0,255,0,1)';
    // context.fillRect(0, 0, 400, 300)
    var sun2 = new Image();
    sun2.src = 'img/below.png';
    context.drawImage(sun2,0,0);    

    //draw the link
    context.font='16px sans-serif';
    context.fillStyle = "#0000ff";
    context.fillText(linkText,linkX,linkY);
    linkWidth=context.measureText(linkText).width;
  }

  // Initialization sequence.
  function initImageView() {
    // Find the canvas element.
    canvas = document.getElementById('imageView');
    if (!canvas) {
      alert('Error: I cannot find the canvas element!');
      return;
    }

    if (!canvas.getContext) {
      alert('Error: no canvas.getContext!');
      return;
    }

    // Get the 2D canvas context.
    context = canvas.getContext('2d');
    if (!context) {
      alert('Error: failed to getContext!');
      return;
    }

    // Fill with background (then it will be an image)
    // context.fillStyle = 'rgba(255,0,0,1)';
    // context.fillRect(0, 0, 400, 300)
    var sun = new Image();
    sun.src = 'img/above.png';
    context.drawImage(sun,0,0);


    // Attach the mousemove event handler.
    canvas.addEventListener('mousemove', ev_mousemove, false);
    // TODO: have this working also on iOS with touch
    //canvas.addEventListener('dragover', ev_mousemove, false);
    canvas.addEventListener('click', ev_click, false);
  }

  // The mousemove event handler.
  var started = false;
  function ev_mousemove (ev) {
    var x, y;

    // Get the mouse position relative to the canvas element.
    if (ev.layerX || ev.layerX == 0) { // Firefox
      x = ev.layerX;
      y = ev.layerY;
    } else if (ev.offsetX || ev.offsetX == 0) { // Opera
      x = ev.offsetX;
      y = ev.offsetY;
    }

    //is the mouse over the link?
    if(x>=linkX && x <= (linkX + linkWidth) && y<=linkY && y>= (linkY-linkHeight)){
        document.body.style.cursor = "pointer";
        inLink=true;
    }
    else{
        document.body.style.cursor = "";
        inLink=false;
    }


    // clear the rectangle
    context.clearRect(x,y,30,30)
    
  }

  //if the link has been clicked, go to link
  function ev_click(e) {
    if (inLink)  {
      window.location = linkText;
    }
  }

  initTextView();
  initImageView();
}, false); }
