import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  build: {
    assetsInlineLimit: 0  // Prevent small assets from being inlined as base64 in the JS bundle
  },
  assetsInclude: ["assets/**/*"],
  base: "./"              // Ensure relative paths for GitHub Pages
});
