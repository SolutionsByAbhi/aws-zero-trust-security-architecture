from  flask import  Flask,  jsonify,  request

app  =  Flask(__name__)

@app.route("/health")
def  health():
       return  jsonify({"status":  "ok"})

@app.route("/data")
def  data():
       user  =  request.headers.get("x-zt-user", "unknown")
       return  jsonify({"message":  f"Hello,  {user}.  This is  a  protected  internal  API."})

if  __name__  ==  "__main__":
       app.run(host="0.0.0.0", port=80)
