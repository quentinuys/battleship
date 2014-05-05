$(function(){

	$('#fire_clever').on('click', function(){
		$.ajax({
		  type: "POST",
		  url: "/fire_nuke",
		  dataType: "script",
	    beforeSend: function(xhr) {
	    	xhr.setRequestHeader("Accept", "text/javascript");
	    },
		  data: {"oponent_id" : $('#oponent_id').val(),
						 "player_id" : $('#player_id').val()}
		});
	})

	$('#show_player').on('click', function(){
		$('.board-oponent').fadeOut(400);
		$('.board-player').fadeIn(600);
	})

	$('#show_oponent').on('click', function(){
		$('.board-oponent').fadeIn(600);
		$('.board-player').fadeOut(400);
	})

	var player = $('#player');
	var oponent = $('#oponent');

	if(player.length > 0 && oponent.length > 0){
		var player_grid = player[0].getContext('2d');
		var oponent_grid = oponent[0].getContext('2d');

		drawGrid(player_grid);
		drawGrid(oponent_grid);
		drawShips();
	}
})

function drawShips(){
	$.ajax({
		  type: "POST",
		  url: "/draw_ships",
		  dataType: "script",
	    beforeSend: function(xhr) {
	    	xhr.setRequestHeader("Accept", "text/javascript");
	    },
		  data: {"oponent_id" : $('#oponent_id').val(),
						 "player_id" : $('#player_id').val()}
		});
}

function drawGrid(grid){
	var grid_size = 60;
	drawVertical(grid, grid_size);
	drawHorizontal(grid, grid_size);
}

function drawHorizontal(grid, grid_height){
	for(i=0; i < 10; i++){
		grid.moveTo(0, (grid_height * i));
		grid.lineTo(600, (grid_height * i));
		grid.stroke();
	}
}
function drawVertical(grid, grid_width){
	for(i=0; i < 10; i++){
		grid.beginPath();
		grid.moveTo((grid_width * i), 0);
		grid.lineTo((grid_width * i), 600);
		grid.stroke();
		grid.closePath();
	}
}

function drawHit(grid, x, y){
	var grid_size = 60;
	var startOne = ((x-1) * grid_size);
	var startTwo = ((y-1) * grid_size);

	grid.beginPath();
	grid.strokeStyle = "rgba(255, 0, 0, .8)";
	grid.moveTo(startOne, startTwo);
	grid.lineTo((startOne + grid_size), (startTwo + grid_size));
	grid.stroke();
	grid.moveTo((startOne + grid_size), startTwo);
	grid.lineTo(startOne, (startTwo + grid_size));
	grid.stroke();
	grid.closePath();
}

function drawMiss(grid, x, y){
	var grid_size = 60;
	var x_pos = (x * grid_size) - (grid_size / 2);
	var y_pos = (y * grid_size) - (grid_size / 2);
  
  grid.fillStyle = "rgba(0, 255, 0, .8)";
	grid.beginPath();
	grid.arc(x_pos, y_pos, 20, 0, Math.PI*2, true);
	grid.fill();
	grid.closePath();
}

function drawShip(grid, x, y, size, direction){
	var grid_size = 60;
	var shipLength = size * grid_size;
	var shipWidth = grid_size;

	var startX = (x * grid_size) + 8;
	var startY = (y * grid_size) + 8;

	if(direction == "vertical"){
		var endX = shipWidth - 16;
		var endY = shipLength - 16;
	}else{
		var endX = shipLength - 16;
		var endY = shipWidth - 16;
	}

	grid.fillStyle = "rgba(90, 90, 90, 1)"
	grid.beginPath();
	grid.rect(startX, startY, endX, endY);
	grid.closePath();
	grid.fill();

}

