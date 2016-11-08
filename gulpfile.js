var gulp = require('gulp');
var ghPages = require('gulp-gh-pages');

var prodDistFolderName = 'dist';
var deployProdTaskName = 'deploy';
gulp.task(deployProdTaskName, function() {
  return gulp.src('./'+ prodDistFolderName +'/**/*')
	  .pipe(ghPages());
});