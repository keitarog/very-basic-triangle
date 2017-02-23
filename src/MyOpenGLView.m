
#include <OpenGL/gl3.h>

#import <Cocoa/Cocoa.h>
#import "MyOpenGLView.h"


@implementation MyOpenGLView {
  GLuint _vbo;
  GLuint _program;
  GLint _uniform_color;
  float _timer;
}


// do a process every frame
- (void)doRenderInGLContext:(float)frameTime {
  
  // calculate elapsed time
  _timer += frameTime;
  
  // clean up our canvas
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  // specify a color of triangle
  // gradually changes its brightness using circular function.
  float speed = 2.0;
  float brightness = (cosf(_timer * speed) + 1.0f) * 0.5f;
  glUniform4f(_uniform_color, brightness, 0, 0, 1.0);
  
  // draw a triangle
  glEnableVertexAttribArray(0);
  glBindBuffer(GL_ARRAY_BUFFER, _vbo);
  glVertexAttribPointer(
    0, // layout number - declared at vertex shader
    3, 
    GL_FLOAT,
    GL_FALSE,
    0, 
    (void*)0
  );
  
  glDrawArrays(GL_TRIANGLES, 0, 3);
  glDisableVertexAttribArray(0);
}


// do a process once for preparation
- (void)doPrepareInGLContext {
  NSLog(@"PREPARE");
  
  _timer = 0;

  GLuint VertexArrayID;
  glGenVertexArrays(1, &VertexArrayID);
  glBindVertexArray(VertexArrayID);
  
  static const GLfloat g_vertex_buffer_data[] = {
     -1.0f, -1.0f, 0.0f,
     1.0f, -1.0f, 0.0f,
     0.0f,  1.0f, 0.0f,
  };
  
  GLuint vertexbuffer;
  glGenBuffers(1, &vertexbuffer);
  glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);
  _vbo = vertexbuffer;
  
  NSUInteger program = 0;
  NSError *error = nil;

  if (STGraphicsCreateProgramDefault(&program, &error)) {
    glUseProgram(program);

    NSLog(@"SHADER PROGRAM CREATED");
    
    _uniform_color = glGetUniformLocation(program, "fragmentColor");
    _program = program; 
  }
  else {
    NSLog(@"%@", error);
  }
}

@end

