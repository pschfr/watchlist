var gulp = require('gulp'),
	util = require('gulp-util'),
	vftp = require('vinyl-ftp'),
	svgs = require('gulp-svgstore')
	smin = require('gulp-svgmin'),
	path = require('path');

// https://github.com/w0rm/gulp-svgstore#usage
gulp.task('default', function() {
	return gulp.src('public/svg/*.svg').pipe(smin(function(file) {
		var prefix = path.basename(file.relative, path.extname(file.relative));
		return {
			plugins: [{
				cleanupIDs: {
					prefix: prefix + '-',
					minify: true
				}
			}]
		}
	})).pipe(svgs()).pipe(gulp.dest('public/svg'));
});

gulp.task('deploy', function() {
	var conn = vftp.create({
		host: 'paulmakesthe.net',
		user: 'username',
		pass: 'password',
		parallel: 8,
		log: util.log
	}),
	globs = 'www/**';

	return gulp.src(globs, { buffer: false })
		  .pipe(conn.newer('/public_html/watchlist'))
		  .pipe(conn.dest('/public_html/watchlist'));
});
