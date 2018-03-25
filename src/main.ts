import {vec3, mat4, vec4} from 'gl-matrix';
import * as Stats from 'stats-js';
import * as DAT from 'dat-gui';
import Square from './geometry/Square';
import Cube from './geometry/Cube';
import Mesh from './geometry/Mesh';
import OpenGLRenderer from './rendering/gl/OpenGLRenderer';
import Camera from './Camera';
import {setGL} from './globals';
import {readTextFile} from './globals';
import ShaderProgram, {Shader} from './rendering/gl/ShaderProgram';
import Texture from './rendering/gl/Texture';

// Define an object with application parameters and button callbacks
 const controls = {
   'depthOfField': false,
  'pointilism': false,
 };

 // contains 1 in index of each post process to be applied in OpenGlRenderer
 let processes: Array<number> = [0, 0, 0];

// TODO: replace with your scene's stuff

let objAlpaca: string;
let alpaca: Mesh;
let texAlpaca: Texture;
let objTree: string;
let tree: Mesh;
let objPlane: string;
let plane: Mesh;


var timer = {
  deltaTime: 0.0,
  startTime: 0.0,
  currentTime: 0.0,
  updateTime: function() {
    var t = Date.now();
    t = (t - timer.startTime) * 0.001;
    timer.deltaTime = t - timer.currentTime;
    timer.currentTime = t;
  },
}


function loadOBJText() {
  objAlpaca = readTextFile('../resources/obj/alpaca.obj')
  objTree = readTextFile('../resources/obj/tree.obj')
  objPlane = readTextFile('../resources/obj/plane.obj')
}


function loadScene() {
  alpaca && alpaca.destroy();
  tree && tree.destroy();
  plane && plane.destroy();

  alpaca = new Mesh(objAlpaca, vec3.fromValues(0, 0, 0), 2.0, vec3.fromValues(0.0, 0.0, 0.0));
  alpaca.create();

  plane = new Mesh(objPlane, vec3.fromValues(0, 0, 0), 2.0, vec3.fromValues(0.0, 0.0, 0.0));
  plane.create();

  tree = new Mesh(objTree, vec3.fromValues(-10, 0, 0), 2.0, vec3.fromValues(0.0, 0.0, 0.0));
  tree.create();

  texAlpaca = new Texture('../resources/textures/alpaca.jpg')
  
}


function main() {
  // Initial display for framerate
  const stats = Stats();
  stats.setMode(0);
  stats.domElement.style.position = 'absolute';
  stats.domElement.style.left = '0px';
  stats.domElement.style.top = '0px';
  document.body.appendChild(stats.domElement);

  // Add controls to the gui
   const gui = new DAT.GUI();
   var shaders = gui.addFolder('Post Processes');
   var depthOfField = shaders.add(controls, 'depthOfField');
   var pointilism = shaders.add(controls, 'pointilism');
   

  // get canvas and webgl context
  const canvas = <HTMLCanvasElement> document.getElementById('canvas');
  const gl = <WebGL2RenderingContext> canvas.getContext('webgl2');
  if (!gl) {
    alert('WebGL 2 not supported!');
  }
  // `setGL` is a function imported above which sets the value of `gl` in the `globals.ts` module.
  // Later, we can import `gl` from `globals.ts` to access it
  setGL(gl);

  // Initial call to load scene
  loadScene();

  const camera = new Camera(vec3.fromValues(0, 9, 50), vec3.fromValues(0, 9, 0));

  const renderer = new OpenGLRenderer(canvas);
  renderer.setClearColor(0, 0, 0, 1);
  gl.enable(gl.DEPTH_TEST);

  const standardDeferred = new ShaderProgram([
    new Shader(gl.VERTEX_SHADER, require('./shaders/standard-vert.glsl')),
    new Shader(gl.FRAGMENT_SHADER, require('./shaders/standard-frag.glsl')),
    ]);

  standardDeferred.setCamPos(camera.position);
  standardDeferred.setupTexUnits(["tex_Color"]);
  let invViewProj = mat4.create();
  mat4.invert(invViewProj, camera.projectionMatrix);
  standardDeferred.setViewProjMatrix(invViewProj);

  function tick() {

    depthOfField.onChange(function() {
      if(controls.depthOfField.valueOf() == true) {
        processes[0] = 1;
      } else {
        processes[0] = 0;
      }
    });

    pointilism.onChange(function() {
      if(controls.pointilism.valueOf() == true) {
        processes[1] = 1;
      } else {
        processes[1] = 0;
      }
    });
    

    camera.update();
    standardDeferred.setCamPos(camera.controls.eye);
    stats.begin();
    gl.viewport(0, 0, window.innerWidth, window.innerHeight);
    timer.updateTime();
    renderer.updateTime(timer.deltaTime, timer.currentTime);

    standardDeferred.bindTexToUnit("tex_Color", texAlpaca, 0);

    renderer.clear();
    renderer.clearGB();

    // TODO: pass any arguments you may need for shader passes
    // forward render mesh info into gbuffers
    renderer.renderToGBuffer(camera, standardDeferred, [alpaca, tree, plane]);
    // render from gbuffers into 32-bit color buffer
    renderer.renderFromGBuffer(camera);
    // apply 32-bit post and tonemap from 32-bit color to 8-bit color
    renderer.renderPostProcessHDR(processes);
    // apply 8-bit post and draw
    renderer.renderPostProcessLDR();

    stats.end();
    requestAnimationFrame(tick);
  }

  window.addEventListener('resize', function() {
    renderer.setSize(window.innerWidth, window.innerHeight);
    camera.setAspectRatio(window.innerWidth / window.innerHeight);
    camera.updateProjectionMatrix();
  }, false);

  renderer.setSize(window.innerWidth, window.innerHeight);
  camera.setAspectRatio(window.innerWidth / window.innerHeight);
  camera.updateProjectionMatrix();

  // Start the render loop
  tick();
}


function setup() {
  timer.startTime = Date.now();
  loadOBJText();
  main();
}

setup();
