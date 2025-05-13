export const convertToCSV = (objArray: any[]) => {
  const fields = Object.keys(objArray[0])
  const replacer = (key: any, value: any) => (value === null ? "" : value)
  let csv: any[] | string = objArray.map((row) =>
    fields.map((fieldName) => JSON.stringify(row[fieldName], replacer)).join(","),
  )
  csv.unshift(fields.join(",")) // add header column

  csv = csv.join("\r\n")

  return csv
}
