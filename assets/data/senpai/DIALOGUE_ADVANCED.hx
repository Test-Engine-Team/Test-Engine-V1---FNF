function pixelLike(t:Float)
	return Math.floor(t * 5) / 5;

function createPost(bgTween)
	bgTween.ease = pixelLike;

function onFinish(finishTween)
	finishTween.ease = pixelLike;

function newPortait(enterTween)
	enterTween.ease = pixelLike;