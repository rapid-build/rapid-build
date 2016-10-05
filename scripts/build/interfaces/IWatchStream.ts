/* Interface from gulp-watch def
 ********************************/
interface IWatchStream extends NodeJS.ReadWriteStream {
    add(path: string | Array<string>): NodeJS.ReadWriteStream;
    unwatch(path: string | Array<string>): NodeJS.ReadWriteStream;
    close(): NodeJS.ReadWriteStream;
}

export default IWatchStream;