button = questdlg(sprintf('You are about to reclone the lastest version of the SDK.\n Do you wish to keep your local changes? \n(If you press no, all local changes are deleted) '),'Do you want to proceed?','Cancel') ;
    switch button
        case 'Yes'
            !git stash
            !git pull origin master
            !git stash pop
        case 'No'
            !git reset --hard
            !git pull origin master 
        case 'Cancel'
            error('Script aborted - User pressed cancel.')
        case ''
           error('Script aborted - User pressed cancel.')
    end