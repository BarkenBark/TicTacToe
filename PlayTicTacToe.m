function outcome = PlayTicTacToe(challengerNetwork, accepterNetwork)
    %Return 1 if challenger wins, -1 if challenger loses, 0 if a tie
    
    %boardState contains a 0 where no piece is set, 1 where challenger has
    %a piece set, -1 where accepter has a piece set
    boardState = zeros(3,3);
    boardState = boardState(:);
    currentPlayerIndex = 1;
    
    gameIsRunning = true;
    while gameIsRunning
        if currentPlayerIndex == 1
            output = challengerNetwork.ForwardPropagate(boardState);
        elseif currentPlayerIndex == -1
            output = accepterNetwork.ForwardPropagate(boardState);
        end
        boardState = GetNewBoardState(output, boardState, currentPlayerIndex);
        gameState = EvaluateGameState(boardState);
        if ~strcmp(gameState, 'running')
            gameIsRunning = false;
        end
        currentPlayerIndex = -1*currentPlayerIndex;
    end
    
    if strcmp(gameState, 'challengerWin')
        outcome = 1;
    elseif strcmp(gameState, 'accepterWin')
        outcome = -1;
    elseif(strcmp(gameState, 'tie')
        outcome = 0;
    end
    
end