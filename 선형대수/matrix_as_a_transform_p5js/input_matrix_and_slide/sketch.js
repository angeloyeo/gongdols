let my_slider;

function setup() {
  createCanvas(700, 400);
  my_slider = createSlider(0, 255, 0);
  my_slider.position(450, 350);
  my_mtx = [
    [1, 3],
    [2, 1],
    [5, 3]
  ];
  
  eye = [
    [1, 1],
    [0, 1]
  ]
  my_vec = [
    [2],
    [1]
  ];
  
  res = mat_mul(my_mtx,eye);
  print(res)

}

function draw() {
  colorMode(RGB);
  background(200);
  draw_axis();
  draw_dots();
  my_slider.value()

}

function draw_axis() {
  colorMode(RGB);
  fill(255);
  noStroke();
  rect(20, 20, 360, 360)

  // edge
  stroke(0);
  strokeWeight(0.5);
  line(20, 380, 380, 380); // horizontal
  line(20, 20, 20, 380); // vertical

  // ticks
  tick_height = 5;
  tick_interval = 360 / 9;
  strokeWeight(0.8);
  tick_start = 30;
  for (i = 0; i < 9; i++) {

    line(tick_start + 10 + i * tick_interval, 380,
      tick_start + 10 + i * tick_interval, 380 - tick_height); // xticks

    line(tick_start - 10, tick_start + 10 + i * tick_interval,
      tick_start - 10 + tick_height, tick_start + 10 + i * tick_interval); // yticks
  }

  // grids
  grid_length = 360;
  stroke(200);
  strokeWeight(0.5);
  for (i = 0; i < 9; i++) {
    line(tick_start + 10 + i * tick_interval, 380,
      tick_start + 10 + i * tick_interval, 380 - grid_length); // xtick

    line(tick_start - 10, tick_start + 10 + i * tick_interval,
      tick_start - 10 + grid_length, tick_start + 10 + i * tick_interval); //ytick
  }

  // numbers on axis
  text_dist = 12;
  fill(0)
  for (i = 0; i < 9; i++) {
    textAlign(CENTER);
    text(-8 + i * 2,
      10 + tick_start + i * tick_interval,
      380 + text_dist); // x-axis
    textAlign(RIGHT);
    text(8 - i * 2,
      30 - text_dist,
      3 + tick_start + 10 + i * tick_interval); // y-axis
  }
}

function draw_dots() {
  my_mtx = [
    [1, 3],
    [2, 1]
  ];
  colorMode(HSB, 100);
  let locX = [];
  let locY = [];
  let loc_pair = [
    [],
    []
  ];

  n_dots = 15;

  for (i = 0; i < n_dots; i++) {
    locX[i] = map(-1 + i * 2 / (n_dots - 1), -1, 1, 180, 220) // center: 200
    locY[i] = map(-1 + i * 2 / (n_dots - 1), -1, 1, 180, 220) // center: 200
  }

  ii = 0;
  for (i = 0; i < n_dots; i++) {
    for (j = 0; j < n_dots; j++) {
      loc_pair[ii] = [locX[j], locY[i]];
      ii++;
    }
  }
  
  
  ii = 0;
  for (i = 0; i < n_dots; i++) {
    for (j = 0; j < n_dots; j++) {
      temp_fill = map(ii, 0, 255, 0, 100);
      fill(temp_fill, 100, 100, 70);
      noStroke();
      ellipse(loc_pair[ii][0], loc_pair[ii][1], 4);
      ii++;
    }

  }

}

function mat_sub(A, B) {
  let res_mtx = [
    [],
    []
  ];
  for (i = 0; i < 2; i++) {
    for (j = 0; j < 2; j++) {
      res_mtx[j][i] = A[j][i] - B[j][i];
    }
  }
  return res_mtx
}

function mat_mul(A, B) {
  let res = [];

  for (i = 0; i < A.length; i++) {
    res[i] = [];
    for (j = 0; j < B[0].length; j++) {
      res[i][j] = 0; // initialization
      for (k = 0; k < A[0].length; k++) {
        res[i][j] += A[i][k] * B[k][j];

      }
    }
  }
  return res;
}

function mat_transpose(A) {
  let res_mat = [
    [],
    []
  ];
  for (i = 0; i < A[1].length; i++) {
    for (j = 0; j < A[0].length; j++) {
      res_mat[i][j] = A[j][i];
    }
  }
  return res_mat
}