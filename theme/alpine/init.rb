commit e0ecdc551a14a26d6886b9dbf047605c7e80c25d
Author: Davor Ocelic <docelic-motif@spinlocksolutions.com>
Date:   Tue Feb 11 05:18:39 2014 +0100

    Theme-related improvements

diff --git a/theme/alpine/init.rb b/theme/alpine/init.rb
new file mode 100644
index 0000000..82b67bf
--- /dev/null
+++ b/theme/alpine/init.rb
@@ -0,0 +1,22 @@
+require 'theme/alpine/screen'
+require 'theme/alpine/window'
+
+require 'theme/alpine/head'
+require 'theme/alpine/body'
+require 'theme/alpine/status'
+require 'theme/alpine/menu'
+require 'theme/alpine/menuaction'
+
+module TASKMAN
+
+	class Theme::Init < Object
+
+		def initialize *arg
+			super()
+
+			$app.screen= Theme::Screen.new( :name => :screen)
+		end
+
+	end
+
+end
