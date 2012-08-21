require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Tsubomi < Formula
  homepage 'http://code.google.com/p/tsubomi/'
  url 'http://tsubomi.googlecode.com/svn/trunk/'
  sha1 ''
  version '0.0.0-01'
  head 'http://tsubomi.googlecode.com/svn/trunk'

  # depends_on 'cmake' => :build
#depends_on : # if your formula requires any X11/XQuartz components

  def patches
    # Makefile patch
    DATA
  end

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    #system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    #system "make install" # if this fails, try separate make/make install steps
    cd 'src/tsubomi' do
      system "make"
      system "make install"
    end
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test tsubomi`.
    system "false"
  end
end


__END__
diff --git a/src/tsubomi/Makefile b/src/tsubomi/Makefile.homebrew
index 865c145..7f03c57 100644
--- a/src/tsubomi/Makefile
+++ b/src/tsubomi/Makefile
@@ -1,7 +1,8 @@
 CC  = /usr/bin/g++
-BIN = /usr/local/bin/
-LIB = /usr/local/lib/
-INC = /usr/local/include/
+PREFIX = /usr/local/Cellar/tsubomi/0.0.0-01/ 
+BIN = /usr/local/Cellar/tsubomi/0.0.0-01//bin/
+LIB = /usr/local/Cellar/tsubomi/0.0.0-01/lib/
+INC = /usr/local/Cellar/tsubomi/0.0.0-01/include/
 SRC = tsubomi_indexer.cc tsubomi_basic_searcher.cc tsubomi_compressor.cc
 HDR = tsubomi_vertical_code.h tsubomi_indexer.h tsubomi_searcher.h \
       tsubomi_basic_searcher.h tsubomi_compressor.h tsubomi_mmap.h tsubomi_defs.h
@@ -48,6 +49,18 @@ clean:
 	- rm -Rf *.dSYM
 
 install:
+	if [ ! -d $(PREFIX) ]; then \
+		echo ";; mkdir -p $(PREFIX)"; mkdir -p $(PREFIX); \
+	fi
+	if [ ! -d $(LIB) ]; then \
+		echo ";; mkdir $(LIB)"; mkdir $(LIB); \
+	fi
+	if [ ! -d $(BIN) ]; then \
+		echo ";; mkdir $(BIN)"; mkdir $(BIN); \
+	fi
+	if [ ! -d $(INC) ]; then \
+		echo ";; mkdir $(INC)"; mkdir $(INC); \
+	fi
 ifeq ($(UNAME), Linux)
 	cp libtsubomi.so.1.0 $(LIB)
 	/sbin/ldconfig -n $(LIB)
@@ -67,7 +80,13 @@ endif
 	cp tsubomi_mkary $(BIN)
 	cp tsubomi_mkcsa $(BIN)
 	cp tsubomi_search $(BIN)
-	cp tsubomi_*.h $(INC)
+	cp tsubomi_basic_searcher.h $(INC)
+	cp tsubomi_defs.h $(INC)
+	cp tsubomi_mmap.h $(INC)
+	cp tsubomi_vertical_code.h $(INC)
+	cp tsubomi_compressor.h $(INC)
+	cp tsubomi_indexer.h $(INC)
+	cp tsubomi_searcher.h $(INC)
 
 uninstall:
 	- rm -f $(LIB)libtsubomi.so
@@ -79,5 +98,10 @@ uninstall:
 	- rm -f $(BIN)tsubomi_mkary
 	- rm -f $(BIN)tsubomi_mkcsa
 	- rm -f $(BIN)tsubomi_search
-	- rm -f $(INC)tsubomi_*.h
-
+	- rm -f $(INC)tsubomi_basic_searcher.h
+	- rm -f $(INC)tsubomi_defs.h
+	- rm -f $(INC)tsubomi_mmap.h
+	- rm -f $(INC)tsubomi_vertical_code.h
+	- rm -f $(INC)tsubomi_compressor.h
+	- rm -f $(INC)tsubomi_indexer.h
+	- rm -f $(INC)tsubomi_searcher.h


