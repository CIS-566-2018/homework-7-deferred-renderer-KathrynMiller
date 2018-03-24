import {gl} from '../../globals';

abstract class Drawable {
  count: number = 0;

  bufType: WebGLBuffer;
  bufIdx: WebGLBuffer;
  bufPos: WebGLBuffer;
  bufNor: WebGLBuffer;
  bufCol: WebGLBuffer;
  bufUV: WebGLBuffer;

  typeBound: boolean = false;
  idxBound: boolean = false;
  posBound: boolean = false;
  norBound: boolean = false;
  colBound: boolean = false;
  uvBound: boolean = false;

  abstract create() : void;

  destroy() {
    gl.deleteBuffer(this.bufIdx);
    gl.deleteBuffer(this.bufPos);
    gl.deleteBuffer(this.bufNor);
    gl.deleteBuffer(this.bufCol);
    gl.deleteBuffer(this.bufUV);
    gl.deleteBuffer(this.bufType);
  }

  generateIdx() {
    this.idxBound = true;
    this.bufIdx = gl.createBuffer();
  }

  generatePos() {
    this.posBound = true;
    this.bufPos = gl.createBuffer();
  }

  generateType() {
    this.typeBound = true;
    this.bufType = gl.createBuffer();
  }

  generateNor() {
    this.norBound = true;
    this.bufNor = gl.createBuffer();
  }

  generateCol() {
    this.colBound = true;
    this.bufCol = gl.createBuffer();
  }

  generateUV() {
    this.uvBound = true;
    this.bufUV = gl.createBuffer();
  }

  bindIdx(): boolean {
    if (this.idxBound) {
      gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, this.bufIdx);
    }
    return this.idxBound;
  }

  bindPos(): boolean {
    if (this.posBound) {
      gl.bindBuffer(gl.ARRAY_BUFFER, this.bufPos);
    }
    return this.posBound;
  }

  bindType(): boolean {
    if (this.typeBound) {
      gl.bindBuffer(gl.ARRAY_BUFFER, this.bufType);
    }
    return this.typeBound;
  }

  bindNor(): boolean {
    if (this.norBound) {
      gl.bindBuffer(gl.ARRAY_BUFFER, this.bufNor);
    }
    return this.norBound;
  }

  bindCol() : boolean {
    if (this.colBound) {
      gl.bindBuffer(gl.ARRAY_BUFFER, this.bufCol);
    }
    return this.colBound;
  }

  bindUV() : boolean {
    if (this.uvBound) {
      gl.bindBuffer(gl.ARRAY_BUFFER, this.bufUV);
    }
    return this.uvBound;
  }

  elemCount(): number {
    return this.count;
  }

  drawMode(): GLenum {
    return gl.TRIANGLES;
  }
};

export default Drawable;
