import puppeteer from 'puppeteer';

(async() => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Specify the path to your local HTML file
  const filePath = 'index.html';

  // Use file:// protocol to open local files
  const fileUrl = `file://${process.cwd()}/${filePath}`;



  await page.goto(fileUrl, {waitUntil: 'networkidle2'});
  await page.pdf({path: 'page.pdf', format: 'A4'});

  await browser.close();
})();