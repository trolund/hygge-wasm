export const imports = {
    env: {
      abort(_msg: any, _file: any, line: any, column: any) {
        console.error("abort called at index.ts:" + line + ":" + column);
      },
    },
  };