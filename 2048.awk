#! /usr/bin/awk -f

function w_move(board) {
    for(i=5;i<=16;i++) {
      if(board[i]!=" ") {
        j=i
        while(board[j-4]==" ") {
          board[j-4]=board[j]
          board[j]=" "
          j-=4
        }
      }
    }
}

function s_move(board) {
    for(i=12;i>=1;i--) {
      if(board[i]!=" ") {
        j=i
        while(board[j+4]==" ") {
          board[j+4]=board[j]
          board[j]=" "
          j+=4  
        }
      }
    }
}

function d_move(board,start,stop) {
    for(i=start;i<=stop;i+=4) {
      if(board[i]!=" ") {
        j=i
        while(board[j+1]==" ") {
          board[j+1]=board[j]
          board[j]=" "
          j++
          if(j%4==0)
            break
        }
      }
    }
}

function a_move(board,start,stop) {
    for(i=start;i<=stop;i+=4) {
        if(board[i]!=" ") {
          j=i
          while(board[j-1]==" ") {
            board[j-1]=board[j]
            board[j]=" "
            j--
            if(j%4==1)
              break
          }
        }
    } 
}

function a_move_add(board,start,stop) {
    for(i=start;i<=stop;i+=4) {
      if(board[i]!=" ") {
        if(board[i+1]==board[i]) {
          board[i]=board[i]*2
          board[i+1]=" "
        }
      }
    }
}

function d_move_add(board,start,stop) {
    for(i=start;i<=stop;i+=4) {
      if(board[i]!=" ") {
        if(board[i-1]==board[i]) {
          board[i]=board[i]*2
          board[i-1]=" "
        }
      }
    }
}

function random_number(board) {
  random_place= int(rand()*15)+1
  random=2
  if(board[random_place]==" ") {
    board[random_place]=random
  }
  else {
    for(i=1;i<=16;i++) {
      if(board[i]==" ") {
        board[i]=random
        return 0
      }
    } 
    return 1
  }
}

function check_winner(board) {
  for(i=1;i<=16;i++) {
    if(board[i]==2048)
      return 1
  }
  return 0
}

function move(board,input) {
  if(input=="w") {
    w_move(board)
    for(i=1;i<=12;i++) {
      if(board[i]!=" ") {
        if(board[i+4]==board[i]) {
          board[i]=board[i]*2
          board[i+4]=" "
        }
      }
    }
    w_move(board)
  }

  else if(input=="s") {
    s_move(board)
    for(i=16;i>=5;i--) {
      if(board[i]!=" ") {
        if(board[i-4]==board[i]) {
          board[i]=board[i]*2
          board[i-4]=" "
        }
      }
    }
    s_move(board)
  }

  else if(input=="d") {
    d_move(board,3,15)
    d_move(board,2,14)
    d_move(board,1,13)   
    
    d_move_add(board,4,16)
    d_move_add(board,3,15)
    d_move_add(board,2,14)
    
    d_move(board,3,15)
    d_move(board,2,14)
    d_move(board,1,13)
  }
  
  else if(input=="a") {
    a_move(board,2,14)
    a_move(board,3,15)
    a_move(board,4,16)

    a_move_add(board,1,13)
    a_move_add(board,2,14)
    a_move_add(board,3,15)

    a_move(board,2,14)
    a_move(board,3,15)
    a_move(board,4,16)
  }

  else {
    print "Invalid Input !"
    return 1
  }
  return 0
}

function displayBoard(board) {
  print ""
  print "-----------------------------"
  print "|      |      |      |      | "
  printf "| %4s | %4s | %4s | %4s |\n",board[1],board[2],board[3],board[4]
  print "-----------------------------"
  print "|      |      |      |      | "
  printf "| %4s | %4s | %4s | %4s |\n",board[5],board[6],board[7],board[8]
  print "-----------------------------"
  print "|      |      |      |      | "
  printf "| %4s | %4s | %4s | %4s |\n",board[9],board[10],board[11],board[12]
  print "-----------------------------"
  print "|      |      |      |      | "
  printf "| %4s | %4s | %4s | %4s |       score: %d\n",board[13],board[14],board[15],board[16],score
  print "-----------------------------"
  print ""
  printf "Enter your move: "
}

function instructions() {
  print "Movements & Keys"
  print "UP: w"
  print "DOWN: s"
  print "RIGHT: d"
  print "LEFT: a"
}

function initializeBoard(board) {
  firstTile= int(rand()*15)+1
  while((secondTile=int(rand()*15)+1)==firstTile) {
  }
  while(((thirdTile=int(rand()*15)+1)==firstTile) || ((thirdTile=int(rand()*15)+1)==secondTile)) {
  }
  board[firstTile]=4
  board[secondTile]=2
  board[thirdTile]=2
}

BEGIN {
  print ""
  print "      ------ 2048 ------"
  instructions()
  score=0
  srand()
  for(i=1;i<=16;i++) {
    board[i]=" "
  }
  initializeBoard(board)
  displayBoard(board)
}

{
  input=tolower($1)
  invalid=move(board,input)
  if(invalid==1)
    next
  game_over=random_number(board)
  if(game_over==1) {
    print "Game Over! Better luck next time!"
    exit
  }
  score++
  system("clear")
  displayBoard(board)
  win=check_winner(board)
  if(win==1) {
    printf "\nCongratulations! You won the game\n"
    exit
  }
}
