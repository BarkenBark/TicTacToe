function newBoardState = GetNewBoardState(networkOutput, currentBoardState, currentPlayerIndex)
    %No error handling for illegal moves
    
    newBoardState = currentBoardState;
    [~, I] = sort(networkOutput, 'descend'); 

    isEvaluating = true;
    while isEvaluating
        wantedPosition = I(1);
        if currentBoardState(wantedPosition) == 0
            newBoardState(wantedPosition) = currentPlayerIndex;
            isEvaluating = false;
        else
            I(1) = [];
        end
    end

end