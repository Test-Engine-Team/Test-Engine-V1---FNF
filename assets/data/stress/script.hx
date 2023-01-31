import handlers.SubtitleHandler;

function update(elapsed) {
    var subtitleRan = false;
    if (curStep == 736 && !subtitleRan)
    {
        subtitleRan = true;
        SubtitleHandler.addSub('Heh, Pretty Good!', 2.61);
    }
        
}