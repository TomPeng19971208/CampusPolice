defmodule CampusPoliceWeb.RecordController do
  use CampusPoliceWeb, :controller

  alias CampusPolice.Records
  alias CampusPolice.Records.Record

  action_fallback CampusPoliceWeb.FallbackController

  def index(conn, _params) do
    records = Records.list_records()
    render(conn, "index.json", records: records)
  end

  def create(conn, %{"record" => record_params}) do
    with {:ok, %Record{} = record} <- Records.create_record(record_params) do
      record = CampusPolice.Repo.preload(record, [:user])
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.record_path(conn, :show, record))
      |> render("show.json", record: record)
    end
  end

  def get_records_nearby(conn, %{"x" => x, "y" => y}) do
    records = RecordUtil.get_records_nearby(x, y)
    render(conn, "index.json", records: records)
  end

  def show(conn, %{"id" => id}) do
    record = Records.get_record(id)
    render(conn, "show.json", record: record)
  end

  def update(conn, %{"id" => id, "record" => record_params}) do
    record = Records.get_record!(id)

    with {:ok, %Record{} = record} <- Records.update_record(record, record_params) do
      render(conn, "show.json", record: record)
    end
  end

  def delete(conn, %{"id" => id}) do
    record = Records.get_record!(id)

    with {:ok, %Record{}} <- Records.delete_record(record) do
      send_resp(conn, :no_content, "")
    end
  end

  def get_address_info(conn, %{"x"=> x, "y" => y}) do
    %{address: address, zip: zip} = CampusPoliceUtil.API.get_address(x, y)
    render(conn, "address_info.json", data: %{address: address, zip: zip})
  end

  def inform_residents(conn, %{"record_id" => record_id}) do
    record = Records.get_record!(record_id)
    info = record.description
    %{address: address, numbers: numbers} = RecordUtil.get_local_numbers(record.x, record.y)
    msg = address <> "\n" <> info
    CampusPoliceUtil.API.broadcast_msgs(msg, numbers)
    send_resp(conn, :no_content, "")
  end

  def inform_individual(conn, %{"record_id" => record_id, "phone" => phone}) do
    record = Records.get_record!(record_id)
    %{address: address} = CampusPoliceUtil.API.get_address(record.x, record.y)
    if phone == "911" do
      info = "Emergency! (Auto-generated): \n victim: #{record.user.username} \n
      I am not able to speak, don't call me back! Need assistance immediately!"
      msg = address <> "\n" <> info
      CampusPoliceUtil.API.send(msg, phone)
    else
      info = record.description
      msg = address <> "\n" <> info
      CampusPoliceUtil.API.send(msg, phone)
    end
    send_resp(conn, :no_content, "")
  end
end
