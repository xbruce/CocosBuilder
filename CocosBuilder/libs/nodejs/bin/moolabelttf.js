var argv = process.argv;



var cc = {};
cc.c3b = function(r,g,b) {
    return {r:r, g:g, b:b};
};

var getLabelInfo = function(text, defaultColor) {
        var ret = [];

        defaultColor = defaultColor || "255,255,255";
        var arr = defaultColor.split(',');
        defaultColor = cc.c3b(arr[0] >>> 0, arr[1] >>> 0, arr[2] >>> 0);

        var gr = /^<global\s+color\=([\'\"])([^'"]+)\1.*?>(.*?)<\/global>$/gi;
        var r = /<font\s+color\=([\'\"])([^'"]+)\1.*?>([^<]+)<\/font>/gi;
        var r2 = /\{([\d]+),([\d]+),([\d]+)\}(.*)/gi;

        var str = text.replace(gr, function() {
           defaultColor = getColor(arguments[2]);
           return arguments[3];
        }.bind(this));

        str = str.replace(r, function() {
            var color = getColor(arguments[2]);
            return "$${" + color.r + "," + color.g + "," + color.b + "}" + arguments[3] + "$$";
        }.bind(this));

        var arr = str.split('$$');
        for (var i = 0; i < arr.length; i ++) {
            var s = arr[i].trim();
            if (s.length == 0) {
                continue;
            }
            var r = defaultColor.r, g = defaultColor.g, b = defaultColor.b;
            s = s.replace(r2, function() {
                r = arguments[1];
                g = arguments[2];
                b = arguments[3];
                return arguments[4];
            });

            ret.push({r: r, g: g, b: b, text: s});
        }

        return ret;
    };

var getColor  = function(color) {
        var colors = {"red": cc.c3b(255, 0, 0), "white": cc.c3b(255, 255, 255), "black": cc.c3b(0, 0, 0)};
        if (colors[color]) {
            return colors[color];
        }
        var arr = color.split(',');
        if (arr.length == 3) {
            return cc.c3b(arr[0] >>> 0, arr[1] >>> 0, arr[2] >>> 0);
        }
    };
                                  process.stdin.on('data', function(t) {
                                                   var ret = getLabelInfo('' + t);
                                                   process.stdout.write(JSON.stringify(ret));
                                                   });
